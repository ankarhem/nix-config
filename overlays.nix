{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      let
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit (prev) system config;
        };
      in
      {
        unstable = pkgs-unstable;
      }
    )
  ];
}
