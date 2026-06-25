#!/usr/bin/env bash
# check_aur_infected.sh
# =================================================================
# Check installed packages against the Arch Linux compromised-package list
#
# Copyright (c) 2026 Rámon van Raaij
# License: BSD-3-Clause
# Author: Rámon van Raaij | Bluesky: @ramonvanraaij.nl | GitHub: https://github.com/ramonvanraaij | Website: https://ramon.vanraaij.eu
#
# This script fetches the live list of compromised package names published on
# the official Arch Linux HedgeDoc note and reports any that are installed on
# the local system. It also runs three local, high-signal indicator-of-compromise
# (IOC) checks. It never modifies the system: it queries pacman, reads a few local
# files, fetches the public list, and -- only if you opt in at the prompt -- runs a
# read-only `sudo stat` on the BPF filesystem for the eBPF rootkit check.
#
# This is a portable shell port of the original fish version: it has no fish
# dependency and runs under bash and the BusyBox ash shell used by Alpine. It
# uses `set -o pipefail` for robustness, which bash and current BusyBox ash
# support but dash and some other strict-POSIX shells do not -- so it is not a
# pure-POSIX/dash script. Apart from pipefail it avoids bashisms (no arrays,
# no [[ ]], no process substitution), so dropping pipefail would make it
# dash-clean if ever needed.
#
# It performs the following actions:
# 1. Fetches the live package-name list from the official Arch Linux HedgeDoc note.
# 2. Verifies the page looks like the expected note (format guard).
# 3. Extracts only the note body (so page chrome cannot leak in), strips HTML,
#    trims whitespace, keeps valid-looking pkgname lines, and de-duplicates.
# 4. Sanity-checks the parsed count to catch a truncated fetch or format change.
# 5. Pass 1 (faithful to the original): intersects the list with FOREIGN packages
#    (pacman -Qmq) -- packages not provided by any sync database (classic AUR builds).
# 6. Pass 2 (broader): intersects the list with ALL installed packages (pacman -Qq),
#    which also catches AUR packages shipped through a binary repo (e.g. Chaotic-AUR
#    on Garuda / CachyOS) -- a blind spot of pass 1.
# 7. Runs two local indicator-of-compromise checks that do NOT depend on the
#    fetched name list (and so still report even if the fetch fails):
#      a. Scans pacman's per-package install scriptlets for known payload markers,
#         catching the malware even under a renamed or not-yet-listed package.
#      b. Flags a non-empty /etc/ld.so.preload, a classic library-injection /
#         rootkit persistence mechanism that is absent on a clean Arch system.
#      c. Looks for the eBPF rootkit's pinned maps under /sys/fs/bpf
#         (hidden_pids / hidden_names / hidden_inodes), which the payload pins to
#         hide processes, directory entries and socket inodes. /sys/fs/bpf is
#         root-only (mode 0700) on a normal system, so this check is definitive
#         only as root. When run unprivileged at an interactive terminal it
#         offers an opt-in sudo re-check (which prompts for the sudo password and
#         only runs read-only 'stat' on those paths); otherwise it reports
#         INCOMPLETE rather than a misleading "clean".
#
# Usage:
#   ./check_aur_infected.sh        # or: bash check_aur_infected.sh
#
# Exit codes:
#   0  clean -- no listed package name is installed and no indicator of compromise found
#   1  error -- fetch, format, or parse sanity check failed (and no indicator found)
#   2  one or more listed package NAMES are installed (name-level match -- triage)
#   3  a high-confidence indicator of compromise was found (install-scriptlet
#      marker, non-empty /etc/ld.so.preload, or an eBPF rootkit map pinned under
#      /sys/fs/bpf). Outranks 1 and 2.
#
# **Note:**
# - Name matches (exit 2) are by package NAME only. A hit means a same-named
#   package is installed, NOT proof of compromise. Triage each hit before acting:
#       pacman -Qi  <pkg>   # build date, packager, "Validated By: Signature"
#       pacman -Qkk <pkg>   # verify files against recorded checksums
#   A signature-validated official package built well before the incident is
#   almost certainly a benign name collision, not the compromised artifact.
# - Indicator-of-compromise hits (exit 3) are far stronger evidence than a name
#   match and warrant immediate investigation.
# - The eBPF map check (IOC c) needs to read the root-only /sys/fs/bpf, so an
#   unprivileged NON-interactive run (e.g. cron) can only ever report it as
#   INCOMPLETE -- it yields no eBPF coverage. To cover IOC c in automation, run
#   the script as root; interactively it instead offers an opt-in sudo re-check.
# - Requires: curl, pacman, plus sed / grep / sort / comm / mktemp / wc / tr /
#   stat (all standard on Arch). The optional eBPF re-check additionally uses
#   sudo, but only when you opt in at the prompt.
#
# Sources:
# - Original bash script (Kidev):
#     https://gist.github.com/Kidev/85756c3dcad3623ca5604a8135bafd14
# - Fish port (K-4-Z, gist comment):
#     https://gist.github.com/Kidev/85756c3dcad3623ca5604a8135bafd14?permalink_comment_id=6196490
# - Data source, official Arch Linux HedgeDoc note:
#     https://md.archlinux.org/s/SxbqukK6IA
# - eBPF rootkit / pinned-map indicators of compromise:
#     https://ioctl.fail/preliminary-analysis-of-aur-malware/#indicators-of-compromise
# =================================================================

set -o errexit -o nounset -o pipefail

# --- Configuration ---
LIST_URL="https://md.archlinux.org/s/SxbqukK6IA"
# Truncated-fetch / format-change guard: the real list is hundreds of packages,
# so a parse yielding fewer than this almost certainly means a bad fetch. Tune
# down if the upstream list is ever curated below this size.
MIN_EXPECTED=100
# Marker that identifies the HedgeDoc note body; also where extraction starts.
DOC_MARKER='<div id="doc"'
# Known payload markers to hunt for inside pacman install scriptlets, as an
# extended regular expression (ERE). 'atomic-lockfile' is the malicious npm
# package referenced by affected AUR builds' install hooks in the 2026 AUR
# supply-chain compromise; add future campaign markers as alternations, e.g.
# 'atomic-lockfile|some-other-marker'.
IOC_MARKERS='atomic-lockfile'
# eBPF rootkit pinned-map paths to look for under the BPF filesystem. The 2026
# AUR payload pins these maps to hide processes, directory entries and socket
# inodes; a clean system has none. Space-separated (the paths contain no spaces),
# iterated below. Add future pinned-object paths here as the campaign evolves.
BPF_MAPS='/sys/fs/bpf/hidden_pids /sys/fs/bpf/hidden_names /sys/fs/bpf/hidden_inodes'
# Tracks whether any indicator of compromise was found (raises the exit code to 3).
ioc_found=0

# Force the C locale so sort, comm and grep all agree on byte ordering. Without
# this, sort uses LC_COLLATE while comm compares byte-wise, and on a UTF-8 host
# the two disagree on punctuation order, which can make comm miss real matches.
export LC_ALL=C

# --- Dependency check ---
# Fail early with a clear message rather than midway through a pipeline.
for cmd in curl pacman sed grep sort comm mktemp wc tr stat; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: required command '$cmd' not found in PATH." >&2
        exit 1
    fi
done

# --- Scratch space ---
# Temp files replace fish's psub process substitution, which keeps the script
# POSIX-safe (BusyBox ash / dash have no <() ). Cleaned up on any exit.
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT INT TERM
infected="$tmpdir/infected"
foreign_installed="$tmpdir/foreign_installed"
all_installed="$tmpdir/all_installed"
match_foreign="$tmpdir/match_foreign"
match_all="$tmpdir/match_all"
match_repo_only="$tmpdir/match_repo_only"

# --- Helpers: indicator-of-compromise reporting and error escalation ---
# print_ioc_advisory: the call to action shown on every exit-3 path (the normal
# report and the early error exits), kept in one place to avoid drift.
print_ioc_advisory() {
    echo
    echo "INDICATOR OF COMPROMISE reported above -- treat this as serious:"
    echo "  - Investigate the flagged install scriptlet, ld.so.preload entry, or"
    echo "    pinned eBPF map now."
    echo "  - If confirmed, assume full compromise: back up data, reinstall clean,"
    echo "    and rotate all credentials (SSH, GitHub, browser sessions, tokens)."
}

# escalate: shared exit logic so a detected IOC is never lost -- if one was found
# it wins (exit 3 + advisory), otherwise it is a plain error (exit 1). Used by the
# early fetch/format/parse exits and by die_or_escalate below.
escalate() {
    if [ "$ioc_found" -eq 1 ]; then print_ioc_advisory; exit 3; else exit 1; fi
}

# die_or_escalate: print a one-line reason ($1) to stderr, then escalate. Guards
# the otherwise-unguarded collect/intersect commands, whose failure would
# otherwise abort on the raw command status and drop a detected IOC.
die_or_escalate() {
    echo "ERROR: $1" >&2
    escalate
}

# scan_bpf_maps: print each pinned rootkit map in $BPF_MAPS that currently exists,
# one path per line. $1 is an optional command prefix -- empty for the plain
# unprivileged probe, "sudo" for the opt-in elevated re-check -- so the same logic
# serves both callers. `stat` only needs SEARCH permission on the parent dir (not
# read on the map), which is why an unprivileged probe still works as root and the
# sudo prefix lets a normal user reach the root-only /sys/fs/bpf. Output is
# discarded; only the exit status matters.
scan_bpf_maps() {
    _prefix=$1
    for _m in $BPF_MAPS; do
        if $_prefix stat "$_m" >/dev/null 2>&1; then
            printf '%s\n' "$_m"
        fi
    done
}

# --- Indicator-of-compromise checks (local, network-independent) ---
# Run these first so they still report even if the list fetch below fails. All
# three are high-signal and low-false-positive: a clean Arch system normally has
# none of them, so a hit is treated as far stronger evidence than a bare name match.
echo "Checking for indicators of compromise..."

# IOC a: known payload markers in pacman install scriptlets. pacman keeps each
# package's scriptlet at /var/lib/pacman/local/<pkg>/install (world-readable by
# default, so a normal user can read them). A match means the malware's hook
# string is present regardless of the package name, catching renamed or
# not-yet-listed packages.
#
# Capture grep's exit status so its three outcomes can be told apart: 0 = match,
# 1 = no match (clean), >=2 = read error. `|| rc=$?` keeps errexit from aborting
# on the expected non-zero cases while preserving the real status (rc is pre-set
# so nounset is satisfied when grep succeeds). Reporting a read error as "clean"
# would hide a real positive on a hardened / non-root run, so it is surfaced as
# an incomplete check instead.
rc=0
ioc_install=$(grep -lE -- "$IOC_MARKERS" /var/lib/pacman/local/*/install 2>/dev/null) || rc=$?
if [ -n "$ioc_install" ]; then
    ioc_found=1
    echo "  [IOC] install-scriptlet marker(s) matching '$IOC_MARKERS' found in:"
    # Map each matching scriptlet path back to its package directory name using
    # POSIX parameter expansion (no basename/dirname dependency).
    printf '%s\n' "$ioc_install" | while IFS= read -r f; do
        [ -n "$f" ] || continue
        d=${f%/install}
        echo "    - ${d##*/} ($f)"
    done
    # Matches found, but grep also failed to read some files: warn about blind spots.
    [ "$rc" -ge 2 ] && echo "  (note: some scriptlets were unreadable; check may be incomplete -- re-run as root)" >&2
elif [ "$rc" -ge 2 ]; then
    # No match, but the DB could not be fully read -- do NOT present this as clean.
    echo "  install scriptlets: INCOMPLETE -- some scriptlets unreadable, re-run as root" >&2
else
    echo "  install scriptlets: clean"
fi

# IOC b: /etc/ld.so.preload injection. The file is absent or empty on a normal
# Arch system; a non-empty one force-loads a shared library into every
# dynamically linked process -- a classic LD_PRELOAD rootkit / persistence trick.
if [ -s /etc/ld.so.preload ]; then
    ioc_found=1
    echo "  [IOC] /etc/ld.so.preload is non-empty:"
    # Show contents on one line for quick inspection; if it is not readable (e.g.
    # running as a non-root user), say so rather than printing a blank line.
    if [ -r /etc/ld.so.preload ]; then
        echo "    $(tr '\n' ' ' </etc/ld.so.preload)"
    else
        echo "    (unreadable -- inspect manually as root)"
    fi
else
    echo "  /etc/ld.so.preload: clean"
fi

# IOC c: eBPF rootkit pinned maps under /sys/fs/bpf (see scan_bpf_maps above).
# The probe is definitive only when it can search /sys/fs/bpf -- i.e. when this
# script runs as root. Unprivileged, that directory is mode 0700 and the probe
# returns nothing, so the result is "unknown" (NOT clean) until an opt-in sudo
# re-check is run. Tri-state: hit / clean / unknown.
bpf_hits=$(scan_bpf_maps "") || true
if [ -n "$bpf_hits" ]; then
    bpf_status=hit
elif [ -d /sys/fs/bpf ] && [ ! -x /sys/fs/bpf ]; then
    # bpffs exists but we cannot search it: the unprivileged probe is inconclusive.
    bpf_status=unknown
else
    # Either we searched it and found nothing, or bpffs is not mounted at all.
    bpf_status=clean
fi

# When the unprivileged probe was inconclusive, offer a password-prompting sudo
# re-check -- but only at an interactive terminal and only if sudo is installed,
# so non-interactive / cron use stays untouched. `sudo -v` validates credentials
# once up front so a wrong password is told apart from a genuinely absent map
# (both make `sudo stat` exit non-zero) and so the per-map stats do not re-prompt.
if [ "$bpf_status" = unknown ] && [ -t 0 ] && command -v sudo >/dev/null 2>&1; then
    # Prompt/preamble go to stderr (not stdout) so redirecting the report to a file
    # still shows the question on the terminal; `read` takes the reply from stdin.
    {
        echo "  eBPF rootkit maps: /sys/fs/bpf is root-only -- cannot verify as this user."
        echo "    This checks whether the rootkit has pinned any of its hiding maps:"
        for _m in $BPF_MAPS; do echo "      $_m"; done
        echo "    A sudo re-check needs root: sudo will prompt for your password and only"
        echo "    runs read-only 'stat' on those paths -- it modifies nothing."
        printf "    Run the sudo eBPF check now? [y/N] "
    } >&2
    read -r _ans || _ans=""
    case $_ans in
        y | Y | yes | Yes | YES)
            if ! sudo -v; then
                echo "    sudo authentication failed -- eBPF check not completed." >&2
                # bpf_status stays "unknown"; reported as INCOMPLETE below.
            elif ! sudo stat /sys/fs/bpf >/dev/null 2>&1; then
                # Auth succeeded but `sudo stat` itself was denied (e.g. a command-
                # restricted sudoers policy) or errored. An empty per-map result
                # would then be indistinguishable from "maps absent", so it must NOT
                # be reported as clean. Probing the root-only dir itself -- which
                # needs search on the world-searchable /sys/fs, not on /sys/fs/bpf --
                # confirms the re-check can actually read bpffs before we trust it.
                echo "    sudo stat could not read /sys/fs/bpf -- eBPF check not completed." >&2
                # bpf_status stays "unknown"; reported as INCOMPLETE below.
            else
                bpf_hits=$(scan_bpf_maps "sudo") || true
                if [ -n "$bpf_hits" ]; then bpf_status=hit; else bpf_status=clean; fi
            fi
            ;;
        *)
            : # declined; bpf_status stays "unknown" -> INCOMPLETE below.
            ;;
    esac
fi

# Final IOC c verdict.
case $bpf_status in
    hit)
        ioc_found=1
        echo "  [IOC] eBPF rootkit pinned map(s) present:"
        for _m in $bpf_hits; do echo "    - $_m"; done
        ;;
    clean)
        echo "  eBPF rootkit maps: clean"
        ;;
    unknown)
        echo "  eBPF rootkit maps: INCOMPLETE -- /sys/fs/bpf is root-only, re-run as root" >&2
        ;;
esac
echo

# --- Fetch the compromised-package list ---
echo "Fetching infected package list..."

raw=$(curl -fsSL "$LIST_URL") || {
    rc=$?
    echo "ERROR: failed to fetch $LIST_URL (curl exit $rc)" >&2
    # A confirmed indicator outranks an incomplete name check.
    escalate
}

# --- Validate page format ---
# Confirm we actually received the note (not an error page or a body truncated
# before the content starts) before trusting the parse.
if ! printf '%s\n' "$raw" | grep -qF -- "$DOC_MARKER"; then
    echo "ERROR: fetched page does not look like the expected note (missing '$DOC_MARKER')." >&2
    echo "       The note layout may have changed; parse is not trustworthy." >&2
    escalate
fi

# --- Parse the package list ---
# Extract only the note body (from the doc marker onward) so page chrome
# (header, view counts, usernames, timestamps) cannot leak in as stray tokens;
# strip HTML tags; trim surrounding whitespace (the first list entry is indented
# in the render); keep only sane pkgname lines (lowercase / digits / . _ + -);
# de-duplicate. The note renders as one package name per line.
#
# A malformed page can make grep match nothing (pipeline exit 1); that is not a
# crash condition -- the MIN_EXPECTED guard below reports it cleanly -- so the
# trailing `|| true` stops pipefail from aborting here.
{
    printf '%s\n' "$raw" \
        | sed -n "/$DOC_MARKER/,\$p" \
        | sed 's/<[^>]*>//g; s/^[[:space:]]*//; s/[[:space:]]*$//' \
        | grep -E '^[a-z0-9]([a-z0-9_.+-]*[a-z0-9])?$' \
        | sort -u >"$infected"
} || true

pkg_count=$(wc -l <"$infected" | tr -d '[:space:]') || die_or_escalate "wc failed (infected count)"
if [ "$pkg_count" -lt "$MIN_EXPECTED" ]; then
    echo "ERROR: parsed only $pkg_count package(s) (expected >= $MIN_EXPECTED)." >&2
    echo "       The fetch was likely truncated or the note format changed." >&2
    escalate
fi

echo "Checking $pkg_count known infected packages..."
echo

# --- Collect installed packages ---
# Each command in this section and the next is guarded with `|| die_or_escalate`
# so a failure here (e.g. pacman erroring, a full /tmp) cannot silently drop an
# already-detected IOC: it still exits 3 with the advisory instead of aborting
# on the raw command status.
# All installed (always non-empty). pacman -Qq is already one name per line.
pacman -Qq | sort >"$all_installed" || die_or_escalate "could not list installed packages (pacman -Qq)"
# Foreign only (classic AUR builds). On a system with zero foreign packages
# pacman -Qmq can exit non-zero; `|| true` keeps that from aborting under set -e.
{ pacman -Qmq || true; } | sort >"$foreign_installed" || die_or_escalate "could not list foreign packages (pacman -Qmq)"

# --- Intersect with the infected list ---
# All inputs are C-locale sorted, so comm's byte-wise compare agrees with sort.
# Pass 1: foreign packages only (classic AUR builds).
comm -12 "$foreign_installed" "$infected" >"$match_foreign" || die_or_escalate "comm failed (foreign intersect)"
# Pass 2: all installed packages -- also catches AUR packages shipped through a
# binary repo (e.g. Chaotic-AUR on Garuda), which pass 1 misses.
comm -12 "$all_installed" "$infected" >"$match_all" || die_or_escalate "comm failed (all intersect)"
# Packages caught only by the broader pass (repo-provided AUR packages). Foreign
# matches are a subset of all matches, so the lines unique to match_all are exactly
# the repo-only hits.
comm -13 "$match_foreign" "$match_all" >"$match_repo_only" || die_or_escalate "comm failed (repo-only diff)"

total=$(wc -l <"$match_all" | tr -d '[:space:]') || die_or_escalate "wc failed (match_all)"
foreign_n=$(wc -l <"$match_foreign" | tr -d '[:space:]') || die_or_escalate "wc failed (match_foreign)"
repo_n=$(wc -l <"$match_repo_only" | tr -d '[:space:]') || die_or_escalate "wc failed (match_repo_only)"

# --- Report ---
# Clean only when neither the name check nor the IOC checks found anything.
if [ "$total" -eq 0 ] && [ "$ioc_found" -eq 0 ]; then
    echo "Clean: no listed package names installed and no indicators of compromise found."
    exit 0
fi

# Name-level matches (may be empty if only an IOC fired).
if [ "$total" -gt 0 ]; then
    echo "WARNING: $total infected package name(s) found:"
    echo
    echo "Foreign / AUR-built (pacman -Qmq):"
    if [ "$foreign_n" -eq 0 ]; then
        echo "  (none)"
    else
        while IFS= read -r pkg; do
            printf '  - %s\n' "$pkg"
        done <"$match_foreign"
    fi
    echo
    echo "Repo-provided only (e.g. Chaotic-AUR -- missed by the original check):"
    if [ "$repo_n" -eq 0 ]; then
        echo "  (none)"
    else
        while IFS= read -r pkg; do
            printf '  - %s\n' "$pkg"
        done <"$match_repo_only"
    fi
    echo
    echo "You may be affected. Matches are by NAME only -- triage each before acting:"
    echo "  pacman -Qi  <pkg>   # build date, packager, 'Validated By: Signature'"
    echo "  pacman -Qkk <pkg>   # verify files against recorded checksums"
fi

# A high-confidence indicator outranks a name-only match: report it last (so it
# is the final thing on screen) and exit 3.
if [ "$ioc_found" -eq 1 ]; then
    print_ioc_advisory
    exit 3
fi
exit 2
