{mkKey, ...}: let
  inherit (mkKey) mkKeymap;
in {
  programs.nixvim = {
    plugins.flash = {
      enable = true;

      settings = {
        labels = "asdfghjklqwertyuiopzxcvbnm";
        search.mode = "fuzzy";
        jump.autojump = false;

        label = {
          uppercase = false;
          rainbow = {
            enabled = true;
            shade = 9;
          };
        };
      };
    };

    keymaps = [
      (mkKeymap "n" "s" "<cmd>lua require('flash').jump()<cr>" "Jump")
      (mkKeymap "n" "S" "<cmd>lua require('flash').treesitter()<cr>" "Treesitter jump")
    ];
  };
}
