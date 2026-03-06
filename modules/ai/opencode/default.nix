{ inputs, ... }:
let
  glm = "zai-coding-plan/glm-5";
  glmFlash = "zai-coding-plan/glm-4.7-flash";
  gpt = "openai/gpt-5.4";
in
{
  flake.modules.homeManager.opencode =
    { pkgs, ... }:
    {
      imports = [
        (inputs.import-tree ./_plugins)
      ];

      programs.opencode = {
        enable = true;
        package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
        enableMcpIntegration = true;
        settings = {
          theme = "catppuccin";
          tui = {
            scroll_acceleration = {
              enabled = true;
            };
          };
          instructions = [ ./additional_instructions.md ];
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
        };
      };
    };
}
