{
  enable = true;
  servers = {
    tsserver.enable = true;
    html.enable = true;
    cssls.enable = true;
    jsonls.enable = true;
    svelte.enable = true;
    tailwindcss.enable = true;

    csharp-ls.enable = true;
    omnisharp.enable = true;

    lua-ls.enable = true;
    nginx-language-server.enable = true;
    bashls.enable = true;

    rust-analyzer = {
      enable = true;
      installRustc = false;
      installCargo = false;
    };
  };
}
