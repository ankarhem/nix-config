{ inputs, config, ... }:
let
  environment.variables = {
    EDITOR = "nvim";
  };

  flake.modules.nixos.lazyvim = { inherit environment; };
  flake.modules.darwin.lazyvim = { inherit environment; };
  flake.modules.homeManager.lazyvim =
    { pkgs, ... }:
    {
      imports = [
        inputs.lazyvim.homeManagerModules.default
      ];

      # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
      xdg.configFile."nvim/parser".source =
        let
          parsers = pkgs.symlinkJoin {
            name = "treesitter-parsers";
            paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
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

        extraPackages = with pkgs; [
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
      };
    };
in
{
  inherit flake;
}
