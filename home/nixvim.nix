{...}: {
  programs.nixvim = {
    enable = true;

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

    plugins = {
      lightline.enable = true;
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      flash.enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers = {
        tsserver.enable = true;
        lua-ls.enable = true;
        rust-analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
        };
      };
    };
  };
}
