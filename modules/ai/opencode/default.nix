{ inputs, ... }:
{
  flake.modules.homeManager.opencode = {
    imports = [
      (inputs.import-tree ./_plugins)
    ];

    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      settings = {
        theme = "catppuccin";
        tui = {
          scroll_acceleration = true;
        };
        instructions = [ ./additional-instructions.txt ];
        plugin = [
          "@simonwjackson/opencode-direnv@latest"
          "@tarquinen/opencode-dcp@latest"
        ];

        model = "zai-coding-plan/glm-4.7";
        small_model = "zai-coding-plan/glm-4.7-flash";

        provider = {
          "zai-coding-plan" = {
            options.timeout = false;
            models = {
              "glm-4.7" = {
                name = "GLM 4.7";
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
