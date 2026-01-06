{ inputs, ... }:
let
  nix =
    { pkgs, ... }:
    {
      enable = true;
      package = pkgs.nix;

      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "root"
          "@wheel"
          "@admin"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

  flake.modules.nixos.nix = nix;

  # package only exists in cacheix for nixpkgs-darwin
  nixpkgs.overlays = [
    (
      final: prev:
      let
        pkgs-darwin = import inputs.nixpkgs-darwin {
          inherit (prev) system config;
        };
      in
      {
        darwin.linux-builder-x86_64 = pkgs-darwin.darwin.linux-builder-x86_64;
      }
    )
  ];
  flake.modules.darwin.nix =
    { pkgs, ... }:
    {
      imports = [ nix ];
      nix.settings.extra-platforms = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      # remove extra config to hit cache if building for the first time
      nix.linux-builder = {
        enable = true;
        package = pkgs.darwin.linux-builder-x86_64;
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
    };
in
{
  inherit flake;
}
