{ lib, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs }:
    {
      programs.lazyvim = lib.mkIf config.programs.lazyvim.enable {
        extras = {
          lang.markdown = {
            enable = true;
            installDependencies = true;
            installRuntimeDependencies = true;
          };
        };

        extraPackages =
          with pkgs;
          [
            pandoc
            nodePackages.prettier
            markdownlint-cli
            markdownlint-cli2
          ]
          ++ (with pkgs.vimPlugins; [
            vim-markdown-toc
          ]);
      };
    };
}
