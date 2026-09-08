{ inputs, pkgs, ... }:
let
  glmFlash = "zai-coding-plan/glm-5.3-flash";

  glm = "zai-coding-plan/glm-5.3";

  opus = "anthropic/claude-opus-4-8";
  sonnet = "anthropic/claude-sonnet-5";
  fable = "anthropic/claude-fable-5-1";
in
{
  programs.opencode = {
    tui.plugin = [
      # "oh-my-openagent/tui"
    ];
    settings.plugin = [
      # inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.oh-my-opencode
    ];
  };

  # Unified omo config. Omo 5.x reads ~/.omo/omo.jsonc (shared across the
  # opencode/senpi/codex hosts) instead of the old opencode-only
  # ~/.config/opencode/oh-my-openagent.json. Key changes vs the old file:
  #   - fallback_models -> models
  #   - team_mode.{max_members,max_parallel_members,max_wall_clock_minutes}
  #       -> task.team.{...} (other team_mode limits no longer exist)
  #   - ralph_loop, browser_automation_engine, disabled_skills,
  #     git_master.git_env_prefix: dropped from the unified schema
  home.file.".omo/omo.jsonc" = {
    # omo's own 2026-07-opencode-config-unification migration already created
    # this file; take it over from nix.
    force = true;
    text = builtins.toJSON {
      "$schema" =
        "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json";
      git_master = {
        commit_footer = true;
        include_co_authored_by = true;
      };
      task.team = {
        max_members = 8;
        max_parallel_members = 4;
        max_wall_clock_minutes = 120;
      };
      agents = {
        sisyphus = {
          model = glm;
          models = [ sonnet ];
        };
        sisyphus-junior = {
          model = glm;
          models = [ sonnet ];
        };
        # hephaestus = {
        #   model = glm;
        #   models = [ sonnet ];
        # };
        oracle = {
          model = fable;
          models = [
            opus
            glm
          ];
        };
        librarian = {
          model = glmFlash;
          models = [ sonnet ];
        };
        explore = {
          model = glmFlash;
          models = [ sonnet ];
        };
        multimodal-looker = {
          model = glmFlash;
          models = [ sonnet ];
        };
        prometheus = {
          model = fable;
          models = [
            opus
            glm
          ];
        };
        metis = {
          model = opus;
          models = [ glm ];
        };
        momus = {
          model = opus;
          models = [ glm ];
        };
        atlas = {
          model = glm;
          models = [ sonnet ];
        };
      };
      categories = {
        visual-engineering = {
          model = glmFlash;
          models = [ sonnet ];
        };
        ultrabrain = {
          model = opus;
          models = [ glm ];
        };
        deep = {
          model = glm;
          models = [ sonnet ];
        };
        artistry = {
          model = glmFlash;
          models = [ sonnet ];
        };
        quick = {
          model = glmFlash;
          models = [ sonnet ];
        };
        unspecified-low = {
          model = glmFlash;
          models = [ sonnet ];
        };
        unspecified-high = {
          model = opus;
          models = [ glm ];
        };
        writing = {
          model = glmFlash;
          models = [ sonnet ];
        };
      };
    };
  };
}
