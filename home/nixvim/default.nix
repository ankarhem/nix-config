{...}: {
  programs.nixvim = {
    enable = true;

    keymaps = import ./keymaps.nix;

    plugins = {
      lightline.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      which-key.enable = true;

      flash = import ./plugins/flash.nix;
      telescope = import ./plugins/telescope.nix;
      lsp = import ./plugins/lsp.nix;
    };

    colorschemes = {
      base16 = {
        enable = true;
        setUpBar = true;
        colorscheme = "github";
      };
    };

    opts = {
      expandtab = true;
      number = true;
      relativenumber = true;

      clipboard = "unnamedplus";
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
    };

    globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
  };
}
