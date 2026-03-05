{ inputs, ... }:
{
  flake.modules.homeManager.happier-cli =
    { pkgs, ... }:
    {
      home.packages = [
        inputs.nix-happier.packages.${pkgs.stdenv.hostPlatform.system}.happier-cli
      ];
    };
}
