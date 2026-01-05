{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.yaml = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          yamllint
          yq
        ];
      };
    };
}
