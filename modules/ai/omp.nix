{ inputs, ... }:
{
  flake.modules.homeManager.omp = {
    imports = [
      inputs.omp.homeManagerModules.default
    ];

    programs.omp = {
      enable = true;
      settings = {
        modelRoles.default = "zai/glm-5.3";
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
      };
    };
  };
}
