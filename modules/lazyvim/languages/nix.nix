{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.nix = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          nixd
          statix
          nixpkgs-fmt
          alejandra
        ];
      };
    };
}
