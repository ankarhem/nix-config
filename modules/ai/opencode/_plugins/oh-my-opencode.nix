{ pkgs, ... }:
let
  # gpt = "openai/gpt-5.5-fast";

  s_kimi = "synthetic/hf:moonshotai/Kimi-K2.6";
  s_glm = "synthetic/hf:zai-org/GLM-5.1";

  glm = "zai-coding-plan/glm-5-turbo";
  glmFlash = "zai-coding-plan/glm-5-turbo";
  glmVision = "zai-coding-plan/glm-4.6v";

  sonnet = "anthropic/claude-4.6-sonnet";
  opus = "anthropic/claude-opus-4-8";
in
{
  programs.opencode.settings = {
    plugin = [
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
      sisyphus.model = s_glm;
      sisyphus-junior.model = sonnet;
      # hephaestus.model = glm;
      oracle.model = opus;
      librarian.model = glmFlash;
      explore.model = glmFlash;
      multimodal-looker.model = s_kimi;
      prometheus.model = opus;
      metis.model = opus;
      momus.model = opus;
      atlas.model = glm;
    };
    categories = {
      visual-engineering.model = s_kimi;
      ultrabrain.model = opus;
      deep.model = glm;
      artistry.model = s_kimi;
      quick.model = glmFlash;
      unspecified-low.model = sonnet;
      unspecified-high.model = opus;
      writing.model = s_kimi;
    };
  };
}
