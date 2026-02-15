{ inputs, ... }:
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
            "@tarquinen/opencode-dcp@latest"
          ];

          model = "zai-coding-plan/glm-5";
          small_model = "zai-coding-plan/glm-4.7-flash";

          provider = {
            "zai-coding-plan" = {
              options.timeout = false;
              models = {
                "glm-5" = {
                  name = "GLM 5";
                  options = {
                    reasoningEffort = "high";
                    reasoningSummary = "auto";
                    textVerbosity = "low";
                  };
                };
              };
            };
          };
        };
      };
    };
}
