{
  inputs,
  ...
}:
let
  glm = "zai/glm-5.3";
  glmFlash = "zai/glm-5.3-flash";
  fable = "anthropic/claude-fable-5";
  opus = "anthropic/claude-opus-4-8";
  sonnet = "anthropic/claude-sonnet-5";
in
{
  flake.modules.homeManager.omp = {
    imports = [
      inputs.omp.homeManagerModules.default
    ];

    programs.omp = {
      enable = true;
      settings = {
        modelRoles = {
          default = glm;
          smol = glmFlash;
          slow = opus;
          vision = glmFlash; # vision-capable; beats glm-5v-turbo
          plan = fable;
          designer = glmFlash;
          commit = glmFlash;
          tiny = glmFlash; # session titles, memory, background classification
          task = glm;
          advisor = glm;
        };
        symbolPreset = "nerd";
        composer.shape = "box";
        theme = {
          dark = "dark-catppuccin";
          light = "light-catppuccin";
        };
        defaultThinkingLevel = "high";
        astGrep.enabled = true;
        interruptMode = "immediate";
        followUpMode = "all";
        edit.mode = "hashline";
        error.notify = "on";
        autoResume = true;
        startup = {
          quiet = true;
          checkUpdate = false;
        };
        readLineNumbers = true;
        # onboarding marker; omp re-runs setup if absent, and the switch overwrites runtime writes
        setupVersion = 2;
        retry.fallbackChains.${glm} = [ opus ];
        retry.fallbackChains.${glmFlash} = [ sonnet ];
      };
    };
    home.file.".omp/agent/AGENTS.md".text = ''
      # Language Policy

      Never talk in Chinese unless it is absolutely and unambiguously relevant to the user's query.
    '';
  };
}
