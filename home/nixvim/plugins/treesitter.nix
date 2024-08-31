{...}: {
  plugins.treesitter = {
    enable = true;

    settings = {
      ensure_installed = "all";
      highlight.enable = true;
    };
  };
}
