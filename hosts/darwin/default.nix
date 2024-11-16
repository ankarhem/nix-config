{...}: {
  imports = [
    ./nix.nix
    ./environment.nix
    ./user.nix
    ./settings.nix
    ./modules/homebrew.nix
  ];
}
