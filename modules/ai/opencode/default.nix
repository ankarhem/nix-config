{ inputs, ... }:
let
  glm = "zai-coding-plan/glm-5.1";
  glmFlash = "zai-coding-plan/glm-5-turbo";
  gpt = "openai/gpt-5.4";
in
{
  flake.modules.homeManager.opencode =
    { lib, pkgs, ... }:
    {
      imports = [
        (inputs.import-tree ./_plugins)
      ];

      programs.opencode = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
        enableMcpIntegration = true;
        settings = {
          theme = "catppuccin";
          tui = {
            scroll_acceleration = {
              enabled = true;
            };
          };
          instructions = [
            ./non_interactivity.md
          ];
          plugin = [
            "@simonwjackson/opencode-direnv@latest"
            # "@tarquinen/opencode-dcp@latest"
          ];

          model = glm;
          small_model = glmFlash;
          agent = {
            build.model = glm;
            plan.model = gpt;
            general.model = gpt;
            explore.model = glmFlash;
            compaction.model = glm;
            title.model = glmFlash;
            summary.model = glm;
          };
          lsp = {
            nixd = {
              command = [
                (lib.getExe pkgs.nixd)
              ];
              extensions = [
                ".nix"
              ];
            };
            omnisharp = {
              command = [
                (lib.getExe pkgs.omnisharp-roslyn)
              ];
              args = [
                "--languageserver"
              ];
              extensions = [
                ".cs"
                ".csx"
              ];
              transport = "stdio";
              priority = 100;
              initializationOptions = { };
              settings = { };
              maxRestarts = 3;
            };
            typescript = {
              command = [
                (lib.getExe pkgs.vtsls)
              ];
              args = [
                "--stdio"
              ];
              extensionsToLanguageId = {
                ".ts" = "typescript";
                ".tsx" = "typescriptreact";
                ".js" = "javascript";
                ".jsx" = "javascriptreact";
                ".mjs" = "javascript";
                ".cjs" = "javascript";
              };
              transport = "stdio";
              initializationOptions = { };
              settings = { };
              maxRestarts = 3;
            };
          };
        };
      };
    };
}
