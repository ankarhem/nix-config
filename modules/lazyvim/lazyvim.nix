{ inputs, config, ... }:
{
  flake.modules.homeManager.lazyvim =
    { pkgs, pkgs-unstable, ... }:
    {
      imports = [
        inputs.lazyvim.homeManagerModules.default
      ];

      # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
      xdg.configFile."nvim/parser".source =
        let
          parsers = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
          };
        in
        lib.mkForce "${parsers}/parser";

      programs.neovim = {
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
      programs.lazyvim = {
        enable = true;

        pluginSource = "nixpkgs";

        installCoreDependencies = true;

        extraPackages = with pkgs-unstable; [
          gcc
          tree-sitter
        ];

        extras = {
          ai.copilot.enable = true;
          coding = {
            blink.enable = true;
            luasnip.enable = true;
            mini-surround.enable = true;
            yanky.enable = true;
          };
          dap = {
            core.enable = true;
            nlua.enable = true;
          };
          editor = {
            fzf.enable = true;
            inc_rename.enable = true;
            overseer.enable = true;
            telescope.enable = true;
            dial.enable = true;
            snacks_picker.enable = true;
            neo_tree.enable = true;
          };
          formatting.prettier.enable = true;
          linting.eslint.enable = true;
          lsp.none-ls.enable = true;
          test.core.enable = true;
          ui.treesitter_context.enable = true;
          util = {
            dot.enable = true;
            gitui.enable = true;
            gh.enable = true;
            mini_hipatterns.enable = true;
          };
        };

        plugins = {
          colorscheme = ''
            return {
              {
                "LazyVim/LazyVim",
                opts = {
                  colorscheme = "catppuccin",
                },
              },
              {
                "catppuccin/nvim",
                name = "catppuccin",
                opts = {
                  flavour = "auto", -- latte, frappe, macchiato, mocha
                  background = { -- :h background
                    light = "latte",
                    dark = "frappe",
                  },
                },
              },
            }
          '';
          nvim_sops = ''
            return {
              {
                "lucidph3nx/nvim-sops",
                event = { "BufEnter" },
                keys = {
                  { "<leader>fse", vim.cmd.SopsEncrypt, desc = "[S]ops [E]ncrypt" },
                  { "<leader>fsd", vim.cmd.SopsDecrypt, desc = "[S]ops [D]ecrypt" },
                },
                opts = {
                  -- enabled = true,
                  -- debug = false,
                  -- binPath = 'sops',
                  defaults = {
                    -- awsProfile = 'AWS_PROFILE',
                    -- ageKeyFile = 'SOPS_AGE_KEY_FILE',
                    -- gcpCredentialsFile = 'GOOGLE_APPLICATION_CREDENTIALS',
                  },
                },
              },
            }
          '';
        };
      };
    };
}
