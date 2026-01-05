{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.toml = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };
      };
    };
}
