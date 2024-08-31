{...}: {
  imports = [
    ./keymaps.nix

    ./plugins/autocmd.nix
    ./plugins/autopairs.nix
    ./plugins/cmp.nix
    ./plugins/flash.nix
    ./plugins/lsp.nix
    ./plugins/none-ls.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
    ./plugins/which-key.nix
  ];

  enableMan = true;
  viAlias = true;
  vimAlias = true;

  enable = true;

  plugins = {
    direnv.enable = true;
    otter.enable = true;
    luasnip.enable = true;
    chatgpt.enable = true;
    copilot-chat.enable = true;
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
}
