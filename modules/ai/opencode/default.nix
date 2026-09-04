{ inputs, ... }:
let
  glm = "zai-coding-plan/glm-5.3";
  glmFlash = "zai-coding-plan/glm-5.3-flash";

  opus = "anthropic/claude-opus-4-8";
  fable = "anthropic/claude-fable-5-1";
in
{
  flake.modules.homeManager.opencode =
    { lib, pkgs, ... }:
    {
      imports = [
        # (inputs.import-tree ./_plugins)
      ];
      _module.args.inputs = inputs;

      # OpenCode 2 (beta) runs side by side with v1 as `opencode2` and reads
      # the same config; the v2-native `plugins` key below only affects v2.
      home.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
        opencode2
        t3code-desktop
        # zcode
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
            ./cli.md
            ./intelligence.md
            ./language.md
            ./memory.md
            ./non_interactivity.md
          ];
          plugin = [
            "@simonwjackson/opencode-direnv"
            "@ex-machina/opencode-anthropic-auth"
          ];
          # native v2 plugin config (only read by opencode2)
          plugins = [ "opencode2-direnv" ];

          # opencode2 auto-updates itself by default; the binary is pinned
          # by the flake, so only notify about available updates.
          update = "notify";

          model = glm;
          small_model = glmFlash;
          agent = {
            build.model = glm;
            plan.model = fable;
            general.model = opus;
            explore.model = glmFlash;
            compaction.model = glmFlash;
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
