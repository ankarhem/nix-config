{
  enable = true;
  servers = {
    tsserver.enable = true;
    lua-ls.enable = true;
    rust-analyzer = {
      enable = true;
      installRustc = false;
      installCargo = false;
    };
  };
}
