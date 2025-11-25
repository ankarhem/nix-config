{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [
    inputs.lazyvim.homeManagerModules.default
    ./languages/default.nix
    ./plugins/default.nix
  ];

  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.lazyvim = {
    enable = true;

    pluginSource = "latest";

    installCoreDependencies = true;

    treesitterParsers = pkgs-unstable.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;

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
}
