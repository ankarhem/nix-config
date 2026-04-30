{
  flake.modules.homeManager.zed =
    { pkgs, ... }:
    {
      programs.zed-editor = {
        enable = true;
        installRemoteServer = true;
        extensions = [
          "angular"
          "basher"
          "catppuccin-icons"
          "csharp"
          "discord-presence"
          "dockerfile"
          "go"
          "html"
          "jsonnet"
          "just"
          "nix"
          "sql"
          "svelte"
          "toml"
        ];
        extraPackages = with pkgs; [
          delve
          docker-compose-language-service
          gopls
          jsonnet-language-server
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
          languages = {
            CSharp.language_servers = [
              "omnisharp"
              # "!roslyn"
            ];
          };
          agent_servers = {
            OpenCode = {
              type = "custom";
              command = "opencode";
              args = [ "acp" ];
            };
          };
          agent = {
            always_allow_tool_actions = true;
            model_parameters = [ ];
          };
          theme = "One Dark";
          session.trust_all_worktrees = true;
          vim_mode = true;
          base_keymap = "VSCode";
        };
      };
    };
}
