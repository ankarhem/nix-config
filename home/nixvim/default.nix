{...}: {
  programs.nixvim = {
    enable = true;

    keymaps = import ./keymaps.nix;

    plugins = {
      direnv.enable = true;
      lightline.enable = true;
      oil.enable = true;
      luasnip.enable = true;
      which-key.enable = true;
      flash = import ./plugins/flash.nix;
      telescope = import ./plugins/telescope.nix;
      gitsigns = {
        enable = true;

        settings = {
          current_line_blame = true;
        };
      };

      chatgpt.enable = true;
      copilot-chat.enable = true;
      lsp = import ./plugins/lsp.nix;
      treesitter = import ./plugins/treesitter.nix;
    };

    colorschemes = {
      vscode.enable = true;
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
