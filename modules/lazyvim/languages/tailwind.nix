{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.tailwind = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          tailwindcss
        ];
      };
    };
}
