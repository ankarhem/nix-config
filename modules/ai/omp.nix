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
          advisor = glmFlash;
        };
        advisor.enabled = true; # second-model reviewer (flash, role set above)
        symbolPreset = "nerd";
        composer.shape = "box";
        theme = {
          dark = "dark-catppuccin";
          light = "light-catppuccin";
        };
        defaultThinkingLevel = "high";
        astGrep.enabled = true;
        github.enabled = true;
        vault.enabled = true; # Obsidian vault:// read/edit; requires Obsidian CLI toggle (Settings > General > Advanced)
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
        task.maxConcurrency = 8;
        edit.autoRepair.enabled = true;
        secrets.enabled = true;
        statusLine.preset = "nerd";
        display.showTokenUsage = true;
      };
    };
    home.file.".omp/agent/AGENTS.md".text = ''
      # Language Policy

      Never talk in Chinese unless it is absolutely and unambiguously relevant to the user's query.

      # Memory

      Your long-term memory lives in `vault://_/Agents/` — the only vault area you may touch.
      Before non-trivial work, check it: list the folder and read notes relevant to the task.
      When a task closes with a durable lesson, append a dated bullet to `vault://_/Agents/lessons.md`
      (create the file or folder if missing).

      Never read or write anything in the vault outside `vault://_/Agents/` — including vault-wide
      searches — without explicit user approval in the conversation.
    '';
  };
}
