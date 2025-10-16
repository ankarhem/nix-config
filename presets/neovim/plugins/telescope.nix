{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    keymaps = {
      "<leader>/" = {
        mode = "n";
        action = "live_grep";
        options = {
          desc = "Grep (Root Dir)";
        };
      };
    };
  };
}
