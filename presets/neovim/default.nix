{ inputs, ... }:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins/mini.nix
    ./plugins/telescope.nix
    ./lsp.nix
    ./treesitter.nix
  ];

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
      have_nerd_font = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "auto";
        background = {
          light = "latte";
          dark = "frappe";
        };
      };
    };

    plugins = {
      flash.enable = true;
      which-key.enable = true;
      ts-comments.enable = true;
      gitsigns.enable = true;
      # fugitive.enable = true;
      diffview.enable = true;
      todo-comments.enable = true;
      trouble.enable = true;
    };
  };
}
