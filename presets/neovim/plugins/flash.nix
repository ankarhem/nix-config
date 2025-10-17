{
  programs.nixvim.plugins.flash = {
    enable = true;
  };
  programs.nixvim.keymaps = [
    {
      key = "s";
      mode = [
        "n"
        "x"
        "o"
      ];
      action = "<cmd>lua require(\"flash\").jump()<cr>";
      options = {
        desc = "Flash";
      };
    }
    {
      key = "S";
      mode = [
        "n"
        "x"
        "o"
      ];
      action = "<cmd>lua require(\"flash\").treesitter()<cr>";
      options = {
        desc = "Flash Treesitter";
      };
    }
  ];

}
