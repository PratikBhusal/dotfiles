#!/usr/bin/env sh

# Get explicitly installed formulae
brew leaves | xargs brew desc --eval-all 2>/dev/null > formulae.txt

# Get explicitly installed casks
brew ls --casks | xargs brew desc --eval-all 2>/dev/null > casks.txt

# Install homebrew formulae
# awk '{sub(/:/, "", $1); print $1}' formulae.txt | xargs brew install

# Install homebrew casks
# awk '{sub(/:/, "", $1); print $1}' casks.txt | xargs brew install --cask
