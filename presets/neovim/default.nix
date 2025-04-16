{ lib, pkgs, pkgs-unstable, ... }:
let
  requiredPkgs = with pkgs-unstable; [
    ast-grep
    csharpier
    curl
    (dotnetCorePackages.combinePackages [
      dotnetCorePackages.dotnet_8.sdk
      dotnetCorePackages.dotnet_9.sdk
    ])
    fd
    fzf
    gcc
    gnumake
    gofumpt
    gomodifytags
    gotestsum
    gotools
    hadolint
    lazygit
    markdownlint-cli2
    mermaid-cli
    netcoredbg
    nixfmt-classic
    nodePackages.prettier
    nodejs_22
    python312Packages.pylatexenc
    ripgrep
    shfmt
    tectonic
  ];
  lsps = with pkgs-unstable; [
    angular-language-server
    astro-language-server
    gopls
    jsonnet-language-server
    lua-language-server
    nginx-language-server
    nil
    nixd
    omnisharp-roslyn
    stylua
    svelte-language-server
    tailwindcss-language-server
    terraform-ls
    vscode-langservers-extracted
    vtsls
    vue-language-server
  ];
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = requiredPkgs ++ lsps;

    plugins = with pkgs-unstable.vimPlugins; [ lazy-nvim ];

    extraLuaConfig = let
      plugins = with pkgs-unstable.vimPlugins; [
        LazyVim
        SchemaStore-nvim
        bufferline-nvim
        cmp-buffer
        cmp-git
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        crates-nvim
        dashboard-nvim
        dressing-nvim
        flash-nvim
        friendly-snippets
        gitsigns-nvim
        indent-blankline-nvim
        lualine-nvim
        neo-tree-nvim
        neoconf-nvim
        neodev-nvim
        neotest
        neotest-dotnet
        neotest-golang
        noice-nvim
        none-ls-nvim
        nui-nvim
        nvim-cmp
        nvim-dap
        nvim-dap-go
        nvim-lint
        nvim-lspconfig
        nvim-notify
        nvim-spectre
        nvim-treesitter
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        omnisharp-extended-lsp-nvim
        overseer-nvim
        persistence-nvim
        plenary-nvim
        rocks-nvim
        rust-tools-nvim
        rustaceanvim
        # smear-cursor-nvim
        snacks-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        todo-comments-nvim
        tokyonight-nvim
        trouble-nvim
        vim-illuminate
        vim-startuptime
        which-key-nvim
        {
          name = "LuaSnip";
          path = luasnip;
        }
        {
          name = "catppuccin";
          path = catppuccin-nvim;
        }
        {
          name = "mini.ai";
          path = mini-nvim;
        }
        {
          name = "mini.bufremove";
          path = mini-nvim;
        }
        {
          name = "mini.comment";
          path = mini-nvim;
        }
        {
          name = "mini.icons";
          path = mini-nvim;
        }
        {
          name = "mini.indentscope";
          path = mini-nvim;
        }
        {
          name = "mini.pairs";
          path = mini-nvim;
        }
        {
          name = "mini.surround";
          path = mini-nvim;
        }
      ];
      mkEntryFromDrv = drv:
        if lib.isDerivation drv then {
          name = "${lib.getName drv}";
          path = drv;
        } else
          drv;
      lazyPath =
        pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
    in ''
      require("lazy").setup({
        defaults = {
          lazy = true,
        },
        dev = {
          -- reuse files from pkgs.vimPlugins.*
          path = "${lazyPath}",
          patterns = { "." },
          -- fallback to download
          fallback = true,
        },
        install = {
          missing = false,
        };
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- import/override with your plugins
          { import = "extras" },
          { import = "plugins" },
        },
      })
    '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source = let
    parsers = pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths =
        pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };
  in "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
