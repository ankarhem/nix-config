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
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins = {
      lightline.enable = true;
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
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
