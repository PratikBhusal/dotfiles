Managing policies on macOS desktops
================================================================================

To view current policies, run the following:
```sh
plutil -convert json -o firefox-policies.json /Library/Preferences/org.mozilla.firefox.plist
cat firefox-policies.json
```

To Enable policies, run the following:

```sh
sudo defaults write /Library/Preferences/org.mozilla.firefox EnterprisePoliciesEnabled -bool TRUE
```

see:
- https://github.com/mozilla/policy-templates/blob/master/mac/README.md
- https://support.mozilla.org/en-US/kb/customizing-firefox-macos-using-configuration-prof
