{
  pkgs,
  inputs,
  ...
}: let
  lib = import ./lib;
in {
  _module.args.pkgs = pkgs;
  _module.args.inputs = inputs;
  _module.args.mkKey = lib.mkKey;
  _module.args.icons = lib.icons;
  _module.args.opts = {
    border = "rounded";
  };

  imports = [
    ./mappings.nix

    ./plugins/autocmd.nix
    ./plugins/autopairs.nix
    ./plugins/bufferline.nix
    ./plugins/noice.nix
    ./plugins/nvimtree.nix
    ./plugins/session.nix
    ./plugins/cmp.nix
    ./plugins/comment.nix
    ./plugins/copilot.nix
    ./plugins/dashboard.nix
    ./plugins/flash.nix
    ./plugins/lsp.nix
    ./plugins/none-ls.nix
    ./plugins/telescope.nix
    ./plugins/ufo.nix
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
