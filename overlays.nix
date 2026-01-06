{ withSystem, config, ... }:
let
  overridePackages = final: prev: {
    spotify = prev.spotify.overrideAttrs (oldAttrs: {
      src = prev.fetchurl {
        url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
        hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
      };
    });
  };
in
{
  # Expose publically
  flake.overlays.default =
    final: prev: withSystem prev.stdenv.hostPlatform.system ({ config }: config.packages);
  perSystem =
    {
      system,
      config,
      lib,
      pkgs,
      ...
    }:
    {
      packages = lib.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ./packages;
      };
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          config.overlays.default
          overridePackages
        ];
      };
    };
}
