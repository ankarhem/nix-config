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

1. Check that /etc/shells includes fish
2. Change shell with `chsh -s /run/current-system/sw/bin/fish`
3. Install rustc and cargo with `rustup default stable`
4. Install Rosetta 2 `softwareupdate --install-rosetta --agree-to-license`
