{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.lazyvim = {
    enable = true;

    installCoreDependencies = true;

    plugins.colorscheme = builtins.readFile ./plugins/colorscheme.lua;
    plugins.nvim_sops = builtins.readFile ./plugins/nvim-sops.lua;

    extraPackages = with pkgs; [
      (dotnetCorePackages.combinePackages [
        # dotnet-sdk_6
        # dotnet-sdk_7
        dotnet-sdk
        dotnet-sdk_9
        dotnet-sdk_10
      ])
    ];

    treesitterParsers = pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;

    extras = {
      ai.copilot.enable = true;
      editor = {
        fzf.enable = true;
        inc-rename.enable = true;
        overseer.enable = true;
        telescope.enable = true;
      };
      formatting.prettier.enable = true;
      lang = {
        docker = {
          enable = true;
          installDependencies = true;
        };
        git.enable = true;
        json = {
          enable = true;
          installDependencies = true;
        };
        markdown = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = true;
        };
        nix.enable = true;
        dotnet = {
          enable = true;
          installDependencies = true;
          installRuntimeDependencies = false; # added in extraPackages
        };
        rust = {
          enable = true;
          installDependencies = false;
          installRuntimeDependencies = false;
        };
        tailwind = {
          enable = true;
          installDependencies = true;
        };
        toml = {
          enable = true;
          installDependencies = true;
        };
        typescript = {
          enable = true;
          installDependencies = true;
        };
        yaml.enable = true;
      };
      linting.eslint.enable = true;
      lsp.none-ls.enable = true;
      test.core.enable = true;
      ui.treesitter_context.enable = true;
      util = {
        dot.enable = true;
        gitui.enable = true;
        gh.enable = true;
        mini_hipatterns.enable = true;
      };
    };
  };
}
