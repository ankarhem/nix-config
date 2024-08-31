{...}: {
  imports = [
    ./keymaps.nix

    ./plugins/flash.nix
    ./plugins/lsp.nix
    ./plugins/treesitter.nix
    ./plugins/telescope.nix
    ./plugins/cmp.nix
  ];

  enable = true;

  plugins = {
    direnv.enable = true;
    # lightline.enable = true;
    # oil.enable = true;
    luasnip.enable = true;
    which-key.enable = true;
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
