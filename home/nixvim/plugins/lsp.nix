{...}: {
  plugins.lsp = {
    enable = true;
    servers = {
      html.enable = true;
      cssls.enable = true;
      tsserver.enable = true;
      svelte.enable = true;
      tailwindcss.enable = true;
      htmx.enable = true;

      csharp-ls.enable = true;
      omnisharp.enable = true;

      jsonls.enable = true;
      yamlls.enable = true;
      lua-ls.enable = true;
      jsonnet-ls.enable = true;
      nginx-language-server.enable = true;
      bashls.enable = true;
      nil-ls.enable = true;
      nixd.enable = true;

      gopls.enable = true;
      golangci-lint-ls.enable = true;
      templ.enable = true;

      rust-analyzer = {
        enable = true;
        installRustc = false;
        installCargo = false;
      };
    };
  };
}
