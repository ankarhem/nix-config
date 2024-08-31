{...}: {
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
}
