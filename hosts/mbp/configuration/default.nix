{
  self,
  pkgs,
  pkgs-darwin,
  ...
}:
{
  imports = [
    "${self}/presets/claude.nix"
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

  nixpkgs.config.allowUnfree = true;
  nix = {
    enable = true;
    package = pkgs.nix;

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
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
