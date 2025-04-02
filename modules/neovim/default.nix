{ lib, pkgs, ... }:
let
  requiredPkgs = with pkgs; [
    ast-grep
    csharpier
    curl
    fd
    fzf
    gofumpt
    gomodifytags
    gotestsum
    gotools
    lazygit
    markdownlint-cli2
    mermaid-cli
    nixfmt-classic
    nodePackages.prettier
    nodejs_22
    python312Packages.pylatexenc
    ripgrep
    shfmt
    tectonic
  ];
  lsps = with pkgs; [
    angular-language-server
    astro-language-server
    jsonnet-language-server
    lua-language-server
    nginx-language-server
    nil
    stylua
    svelte-language-server
    tailwindcss-language-server
    typescript-language-server
    vscode-langservers-extracted
    vue-language-server
  ];
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = [ ] ++ requiredPkgs ++ lsps;

    plugins = with pkgs.vimPlugins; [ lazy-nvim ];

    extraLuaConfig = let
      plugins = with pkgs.vimPlugins; [
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
        overseer-nvim
        persistence-nvim
        plenary-nvim
        rocks-nvim
        rustaceanvim
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
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          -- The following configs are needed for fixing lazyvim on nix
          -- force enable telescope-fzf-native.nvim
          { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
          -- disable mason.nvim, use programs.neovim.extraPackages
          { "williamboman/mason-lspconfig.nvim", enabled = false },
          { "williamboman/mason.nvim", enabled = false },
          -- import/override with your plugins
          { import = "plugins" },
          -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
          { "nvim-treesitter/nvim-treesitter",
             opts = function(_, opts)
              opts.ensure_installed = {}
            end,
          },
        },
      })
    '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source = let
    parsers = pkgs.symlinkJoin {
      name = "treesitter-parsers";
      paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins:
        with plugins; [
          # styled
          # zig
          angular
          bash
          c
          c_sharp
          css
          diff
          dockerfile
          editorconfig
          fish
          git_config
          git_rebase
          gitattributes
          gitcommit
          gitignore
          go
          goctl
          godot_resource
          gomod
          gosum
          gotmpl
          gowork
          gpg
          graphql
          html
          ini
          javascript
          jq
          jsdoc
          json
          jsonc
          jsonnet
          just
          latex
          lua
          make
          markdown
          nix
          norg
          passwd
          python
          regex
          requirements
          rust
          scss
          sql
          svelte
          templ
          terraform
          toml
          tsx
          typescript
          typst
          vue
          yaml
        ])).dependencies;
    };
  in "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./lua;
}
