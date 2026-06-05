{
  flake.modules.homeManager.zed =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        package = pkgs._unstable.zed-editor;
        installRemoteServer = true;
        extensions = [
          "angular"
          "basher"
          "cargo-tom"
          "catppuccin-icons"
          "codebook"
          "color-highlight"
          "csharp"
          "discord-presence"
          "dockerfile"
          "env"
          "fish"
          "git-firefly"
          "go"
          "html"
          "ini"
          "jsonnet"
          "just"
          "nginx"
          "nix"
          "nunjucks"
          "scss"
          "sql"
          "svelte"
          "terraform"
          "toml"
        ];
        extraPackages = with pkgs; [
          delve
          docker-compose-language-service
          gopls
          jsonnet-language-server
          just-lsp
          nginx-language-server
          nil
          nixd
          omnisharp-roslyn
          svelte-language-server
          tailwindcss-language-server
          vscode-js-debug
          vtsls
          yaml-language-server
        ];
        userSettings = {
          project_panel.dock = "left";
          outline_panel.dock = "left";
          collaboration_panel.dock = "left";
          git_panel.dock = "left";
          languages = {
            CSharp.language_servers = [
              "omnisharp"
              # "!roslyn"
            ];
          };
          agent = {
            dock = "right";
            tool_permissions.default = "allow";
            model_parameters = [ ];
          };
          icon_theme = "Catppuccin Frappé";
          theme = "Ayu Mirage";
          session.trust_all_worktrees = true;
          vim_mode = true;
          base_keymap = "VSCode";
        };
      };
    };
}
