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
        # ~/.agents/skills is shared with opencode; skip skills duplicating omp built-ins
        skills.ignoredSkills = [
          "obsidian-cli" # vault:// is native
          "using-git-worktrees" # omp worktree / task.isolation is native
        ];
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
      Layout: `memory.md` holds generalized principles about the user and their environment;
      `troubleshooting.md` holds recurring failure modes; `projects/<repo>.md` holds per-project
      conventions. This is a starting layout, not a closed set: when a note grows unwieldy or a
      topic deserves its own file, split it and create new topical files (non-project ones
      included) under `vault://_/Agents/`, linking related notes instead of duplicating.

      Before non-trivial work, list the folder and read what is relevant.

      When a task closes with a durable lesson, curate rather than append:
      - Generalize: record the most general principle that is true, with the specific case as an
        example at most. Skip one-off incidents that are already resolved.
      - Merge: read existing notes first; refine or supersede instead of duplicating.
      - Date changed entries.

      Never read or write anything in the vault outside `vault://_/Agents/` — including vault-wide
      searches — without explicit user approval in the conversation.
    '';

    # Upstream catalog gap (can1357/oh-my-pi#9910): zai/glm-5.3-flash is served by
    # api.z.ai/api/anthropic but missing from the bundled models.json (static provider,
    # no runtime discovery). Verified by headless completion 2026-08-27; remove when
    # `omp models find glm-5.3` lists it under zai after an input update.
    home.file.".omp/agent/models.yml".text = ''
      providers:
        zai:
          auth: oauth
          api: anthropic-messages
          baseUrl: https://api.z.ai/api/anthropic
          models:
            - id: glm-5.3-flash
              name: GLM-5.3 Flash
              reasoning: true
              input:
                - text
                - image
              thinking:
                mode: effort
                efforts:
                  - low
                  - high
                  - max
                defaultLevel: max
                requiresEffort: true
              supportsTools: true
              contextWindow: 1000000
              maxTokens: 131072
              # promo pricing until 2026-09-09; doubles to 0.15 / 0.5 / 0.03 after
              cost:
                input: 0.075
                output: 0.25
                cacheRead: 0.015
                cacheWrite: 0
    '';
  };
}
