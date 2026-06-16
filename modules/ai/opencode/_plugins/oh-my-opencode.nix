{ pkgs, ... }:
let
  kimi = "opencode-go/kimi-k2.7-code";

  glm = "zai-coding-plan/glm-5.2";
  glmFlash = "zai-coding-plan/glm-5-turbo";

  sonnet = "anthropic/claude-4.6-sonnet";
  opus = "anthropic/claude-opus-4-8";
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
    };
    ralph_loop = {
      enabled = true;
      default_max_iterations = 25;
    };
    agents = {
      sisyphus.model = glm;
      sisyphus-junior.model = glm;
      # hephaestus.model = glm;
      oracle.model = opus;
      librarian.model = glm;
      explore.model = glm;
      multimodal-looker.model = kimi;
      prometheus.model = opus;
      metis.model = opus;
      momus.model = opus;
      atlas.model = glm;
    };
    categories = {
      visual-engineering.model = kimi;
      ultrabrain.model = opus;
      deep.model = glm;
      artistry.model = kimi;
      quick.model = kimi;
      unspecified-low.model = kimi;
      unspecified-high.model = opus;
      writing.model = kimi;
    };
  };
}
