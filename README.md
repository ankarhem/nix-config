# nix-config

bootstrap first installation with 

```bash
nix run nix-darwin -- switch --flake .
```

rebuild subsequent with
```bash
darwin-rebuild switch --flake .
```

## Manual steps

### Important
* Install Rosetta 2 `softwareupdate --install-rosetta --agree-to-license`
* Check that /etc/shells includes fish
* Change shell with `chsh -s /run/current-system/sw/bin/fish`
* Open raycast and initialize settings, via topbar replace hotkey to cmd+space
* Replace spotlight
    1. System Preferences > Keyboard > Shortcuts > Spotlight and disable the keyboard shortcut.
    2. Open raycast via topbar and change keymap.
* Enable karabiner
    1. Open and follow the instructions
    2. Restart application and go to complex modifications and enable nix
* Enable desktop + documents icloud sync

* Configure betterdisplay
    1. Set Dell display to 1920x1080
    2. Enable HiDPI on Dell display
* Replace with official colemak (TODO: create custom package for this?)
    1. Download keyboard `wget https://colemak.com/pub/mac/Colemak.keylayout -P ~/Library/Keyboard\ Layouts/`
    2. Replace default colemak System Preferences > Keyboard > Input Sources
* Fix yubikey
    1. Add ssh-keys manually from 1password
    2. Fix permission on private key `chmod 400 ~/.ssh/id_ed25519_sk`
    3. Connect key and run `gpg-connect-agent "scd serialno" "learn --force" /bye`

### Not super important

* Enable rectangle
    1. Open and follow the instructions
    2. Open settings and enable auto-start and animation
* Open mos settings and enable autostart
* Open keyboard settings and disable ^+space (changes language)
* Add accounts System Preferences > Internet Accounts
    - Rename email acccounts in Mail app: Settings > Accounts
    - Filter accounts / calendar with focus modes
* Open firefox and login to sync
* Open slack and login using `jakob.ankarhem@norce.io`, select workspaces

## Finding custom settings

- https://macos-defaults.com/
- https://daiderd.com/nix-darwin/manual/index.html

### Diffing to find settings

1. Generate starting point `defaults read > before`
2. Make changes
3. Generate current `defaults read > after`
4. Diff them to find settings `diff before after`