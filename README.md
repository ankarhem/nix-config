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

1. Install Rosetta 2 `softwareupdate --install-rosetta --agree-to-license`
2. Check that /etc/shells includes fish
3. Change shell with `chsh -s /run/current-system/sw/bin/fish`
4. Install rustc and cargo with `rustup default stable`
5. Open firefox and login to sync
6. Open raycast and initialize settings
