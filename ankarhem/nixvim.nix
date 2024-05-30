{ ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    options = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins = {
      lightline.enable = true;
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
    };

    plugins.lsp = {
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
    };
  };
}
