{ pkgs, ... }: {
  # backwards compat; don't change
  system.stateVersion = 4;

  nix.package = pkgs.nix;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  # nix.optimise = {
  #   automatic = true;
  # };

  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    # nix settings for flake support
    experimental-features = [ "nix-command" "flakes" ];
    extra-platforms = [ "x86_64-darwin" "aarch64-darwin" ];
  };
}
