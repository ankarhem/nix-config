{ pkgs, ... }: {
  imports = [
    ./environment.nix
    ./fonts.nix
    ./homebrew.nix
    ./settings.nix
    ./sops.nix
    ./user.nix
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  # backwards compat; don't change
  system.stateVersion = 5;

  nix.enable = true;
  nix.package = pkgs.nix;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  # nix.optimise = {
  #   automatic = true;
  # };

  nix.settings = {
    # nix settings for flake support
    experimental-features = [ "nix-command" "flakes" ];
    extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
