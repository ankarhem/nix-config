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

* Install Rosetta 2 `softwareupdate --install-rosetta --agree-to-license`
* Check that /etc/shells includes fish
* Change shell with `chsh -s /run/current-system/sw/bin/fish`
* Install rustc and cargo with `rustup default stable`
* Open raycast and initialize settings, via topbar replace hotkey to cmd+space
* Replace spotlight
    1. System Preferences > Keyboard > Shortcuts > Spotlight and disable the keyboard shortcut.
    2. Open raycast via topbar and change keymap.
* Enable karabiner
    1. Open and follow the instructions
    2. Restart application and go to complex modifications and enable nix

* Configure betterdisplay
    1. Set to 1920x1080
    2. Enable HiDPI
* Replace with official colemak (TODO: create custom package for this?)
    1. Download keyboard `wget https://colemak.com/pub/mac/Colemak.keylayout -P ~/Library/Keyboard\ Layouts/`
    2. Replace default colemak System Preferences > Keyboard > Input Sources
* Fix yubikey
    1. Add ssh-keys manually from 1password
    2. Fix permission on private key `chmod 400 ~/.ssh/id_ed25519_sk`
    3. Connect key and run `gpg-connect-agent "scd serialno" "learn --force" /bye`

### App initialization

* Add accounts System Preferences > Internet Accounts
    - Rename email acccounts in Mail app: Settings > Accounts
    - Filter accounts / calendar with focus modes
* Open firefox and login to sync
* Open slack and login using `jakob.ankarhem@norce.io`, select workspaces