{ pkgs, pkgs-darwin, ... }:
{
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

  services.tailscale.enable = true;
  # services.tailscale.overrideLocalDns = true;
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];

  # backwards compat; don't change
  system.stateVersion = 5;

  nix.enable = true;
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

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
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    trusted-users = [ "@admin" ];
  };

  # remove extra config to hit cache if building for the first time
  nix.linux-builder = {
    enable = true;
    package = pkgs-darwin.darwin.linux-builder-x86_64;
    ephemeral = true;
    maxJobs = 4;
    config = {
      virtualisation = {
        darwin-builder = {
          diskSize = 40 * 1024;
          memorySize = 8 * 1024;
        };
        cores = 6;
      };
    };
  };
}
