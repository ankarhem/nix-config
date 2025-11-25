{ inputs, pkgs, ... }:
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
    plugins.sops = builtins.readFile ./plugins/sops.lua;

    extraPackages = with pkgs; [
      (dotnetCorePackages.combinePackages [
        # dotnet_6.sdk
        # dotnet_7.sdk
        dotnet_sdk
        dotnet_9.sdk
        dotnet_10.sdk
      ])
    ];

    extras = {
      ai.copilot.enable = true;
      editor = {
        inc-rename.enable = true;
        overseer.enable = true;
        fzf.enable = true;
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
      ui.treesitter-context.enable = true;
      util = {
        dot.enable = true;
        gitui.enable = true;
        mini-hipatterns.enable = true;
      };
      vscode.enable = true;
    };
  };
}
