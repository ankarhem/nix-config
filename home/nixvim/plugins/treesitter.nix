{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        settings = {
          highlight.enable = true;
          incremental_selection.enable = true;
        };
      };
      treesitter-textobjects = {enable = true;};
    };

    extraPlugins = with pkgs.vimPlugins; [nvim-treesitter-textsubjects];
    extraConfigLua = ''
      require("nvim-treesitter.configs").setup({
        textsubjects = {
          enable = true,
          prev_selection = ",", -- (Optional) keymap to select the previous selection
          keymaps = {
            ["."] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
            ["i;"] = { "textsubjects-container-inner", desc = "Select inside containers (classes, functions, etc.)" },
          },
        },
      })
    '';
  };
}
