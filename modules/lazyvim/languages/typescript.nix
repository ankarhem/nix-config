{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.typescript = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages = with pkgs; [
          vtsls
          typescript
          nodePackages.prettier
          tailwindcss
          # eslint_d
          # eslint
        ];
      };
    };
}
