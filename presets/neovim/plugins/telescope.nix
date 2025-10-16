{
  programs.nixvim.plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    keymaps = {
      # Find
      "<leader>/" = {
        mode = "n";
        action = "live_grep";
        options = {
          desc = "Grep (Root Dir)";
        };
      };
      "<leader>ff" = {
        mode = "n";
        action = "git_files";
        options = {
          desc = "Find Files (git)";
        };
      };
      "<leader>fl" = {
        mode = "n";
        action = "find_files";
        options = {
          desc = "Find Local Files";
        };
      };

      # Git
      "<leader>gc" = {
        mode = "n";
        action = "git_commits";
        options = {
          desc = "Git Commits";
        };
      };
      "<leader>gs" = {
        mode = "n";
        action = "git_status";
        options = {
          desc = "Git Status";
        };
      };

      # Search
      "<leader>s\"" = {
        mode = "n";
        action = "registers";
        options = {
          desc = "Registers";
        };
      };
      "<leader>sj" = {
        mode = "n";
        action = "jumplist";
        options = {
          desc = "Jumplist";
        };
      };
    };
  };
}
