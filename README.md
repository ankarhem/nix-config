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
* Open firefox and login to sync
* Open raycast and initialize settings, via topbar replace hotkey to cmd+space
* Replace spotlight
    1. System Preferences > Keyboard > Shortcuts > Spotlight and disable the keyboard shortcut.
    2. Open raycast via topbar and change keymap.
* Open slack and login using `jakob.ankarhem@norce.io`, select workspaces
* Enable karabiner
    1. Open and follow the instructions
    2. Restart application and go to complex modifications and enable nix
