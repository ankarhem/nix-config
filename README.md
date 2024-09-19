# nix-config

## Steps

1. Install Rosetta 2 `softwareupdate --install-rosetta --agree-to-license`
2. Install nix using [determinate systems](https://github.com/DeterminateSystems/nix-installer)
3. Install colemak `curl -O --output-dir ~/Library/Keyboard\ Layouts/ https://colemak.com/pub/mac/Colemak.keylayout`
4. Install git `xcode-select --install`
5. Replace default colemak System Preferences > Keyboard > Input Sources
6. Bootstrap darwin build `nix run --extra-experimental-features flakes --extra-experimental-features nix-command nix-darwin -- switch --flake .#ankarhem`
7. Change shell with `chsh -s /run/current-system/sw/bin/fish`

## Manual steps

### Important
* Open raycast and initialize settings, via topbar replace hotkey to cmd+space
* Make firefox default browser System Preferences > General > Default Web Browser
* Enable karabiner
    1. Open and follow the instructions
    2. Restart application and go to complex modifications and enable nix
* Enable desktop + documents icloud sync
* Configure betterdisplay
    1. Set Dell display to 1920x1080
    2. Enable HiDPI on Dell display
* Fix yubikey
    1. Add ssh-keys manually from 1password
    2. Fix permission on private key `chmod 400 ~/.ssh/id_ed25519_sk`
    3. Connect key and run `gpg-connect-agent "scd serialno" "learn --force" /bye`

### Not super important

* Open mos settings and enable autostart
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
