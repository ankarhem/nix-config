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
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
      flash.enable = true;
      which-key.enable = true;
    };

    plugins.telescope = {
      enable = true;

      keymaps = {
        "<leader>fp" = {
          action = "git_files";
          options.desc = "Telescope Find Project";
        };
        "<leader>ff" = {
          action = "find_files";
          options.desc = "Telescope Find Files";
        };
        "<leader>fg" = {
          action = "live_grep";
          options.desc = "Telescope Find Grep";
        };
        "<leader>fb" = {
          action = "buffers";
          options.desc = "Telescope Find Buffers";
        };
      };
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
