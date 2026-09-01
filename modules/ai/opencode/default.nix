{ inputs, ... }:
let
  glm = "zai-coding-plan/glm-5.3";
  glmFlash = "zai-coding-plan/glm-5.3-flash";

  opus = "anthropic/claude-opus-4-8";
  deepseekV4FlashFree = "opencode/deepseek-v4-flash-free";
in
{
  flake.modules.homeManager.opencode =
    { lib, pkgs, ... }:
    {
      imports = [
        (inputs.import-tree ./_plugins)
      ];

      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        pkgs.local.openchamber-desktop
      ];

      programs.opencode = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
        enableMcpIntegration = true;
        tui = {
          theme = "catppuccin";
          scroll_acceleration = {
            enabled = true;
          };
        };
        settings = {
          instructions = [
            ./non_interactivity.md
            ./language.md
            ./memory.md
          ];
          plugin = [
            inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-opencode
            "@simonwjackson/opencode-direnv"
            "@ex-machina/opencode-anthropic-auth"
            "opencode-vcc@next"
          ];

          model = glm;
          small_model = glmFlash;
          agent = {
            build.model = glm;
            plan.model = opus;
            general.model = opus;
            explore.model = glmFlash;
            compaction.model = deepseekV4FlashFree;
            title.model = glmFlash;
            summary.model = glmFlash;
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
