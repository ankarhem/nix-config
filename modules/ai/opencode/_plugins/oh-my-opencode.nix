{ pkgs, ... }:
let
  glmFlash = "zai-coding-plan/glm-5.3-flash";

  glm = "zai-coding-plan/glm-5.3";

  opus = "anthropic/claude-opus-4-8";
  sonnet = "anthropic/claude-sonnet-5";
  fable = "anthropic/claude-fable-5";
in
{
  programs.opencode = {
    tui.plugin = [
      "oh-my-openagent/tui"
    ];
    settings.plugin = [
      "oh-my-openagent"
    ];
  };

  home.file.".config/opencode/oh-my-openagent.json".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/oh-my-opencode.schema.json";
    disabled_skills = [ "playwright" ];
    browser_automation_engine = {
      provider = "agent-browser";
    };
    team_mode = {
      enabled = true;
      tmux_visualization = false;
      max_parallel_members = 4;
      max_members = 8;
      max_messages_per_run = 10000;
      max_wall_clock_minutes = 120;
      max_member_turns = 500;
      message_payload_max_bytes = 32768;
      recipient_unread_max_bytes = 262144;
      mailbox_poll_interval_ms = 3000;
    };
    ralph_loop = {
      enabled = true;
      default_max_iterations = 25;
      default_strategy = "continue";
    };
    git_master = {
      commit_footer = true;
      include_co_authored_by = true;
      git_env_prefix = "GIT_MASTER=1";
    };
    agents = {
      sisyphus = {
        model = glm;
        fallback_models = [ sonnet ];
      };
      sisyphus-junior = {
        model = glm;
        fallback_models = [ sonnet ];
      };
      # hephaestus = {
      #   model = glm;
      #   fallback_models = [ sonnet ];
      # };
      oracle = {
        model = fable;
        fallback_models = [
          opus
          glm
        ];
      };
      librarian = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      explore = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      multimodal-looker = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      prometheus = {
        model = fable;
        fallback_models = [
          opus
          glm
        ];
      };
      metis = {
        model = opus;
        fallback_models = [ glm ];
      };
      momus = {
        model = opus;
        fallback_models = [ glm ];
      };
      atlas = {
        model = glm;
        fallback_models = [ sonnet ];
      };
    };
    categories = {
      visual-engineering = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      ultrabrain = {
        model = opus;
        fallback_models = [ glm ];
      };
      deep = {
        model = glm;
        fallback_models = [ sonnet ];
      };
      artistry = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      quick = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      unspecified-low = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
      unspecified-high = {
        model = opus;
        fallback_models = [ glm ];
      };
      writing = {
        model = glmFlash;
        fallback_models = [ sonnet ];
      };
    };
  };
}
