{ pkgs, ... }:
{
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      # ensure_installed = "all";

      highlight = {
        enable = true;
      };

      incremental_selection = {
        enable = true;
      };

      indent = {
        enable = true;
      };

      # There are additional nvim-treesitter modules that you can use to interact
      # with nvim-treesitter. You should go explore a few and see what interests you:
      #
      #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
      #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
    };
  };
}
