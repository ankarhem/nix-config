{ pkgs, ... }:
let
  gpt = "openai/gpt-5.5";

  glm = "zai-coding-plan/glm-5.1";
  glmFlash = "zai-coding-plan/glm-5-turbo";
  glmVision = "zai-coding-plan/glm-5v-turbo";

  opus = "anthropic/claude-opus-4-7";
in
{
  programs.opencode.settings = {
    plugin = [
      "oh-my-opencode"
    ];
  };

  home.file.".config/opencode/oh-my-openagent.json".text = builtins.toJSON {
    "$schema" =
      "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
    google_auth = false;
    ralph_loop = {
      enabled = true;
      default_max_iterations = 25;
    };
    agents = {
      sisyphus.model = glm;
      sisyphys-junior.model = glm;
      hephaestus.model = gpt;
      oracle.model = gpt;
      # oracle.variant = "max";
      librarian.model = glm;
      explore.model = glmFlash;
      multimodal-looker.model = glmVision;
      prometheus.model = gpt;
      # prometheus.variant = "max";
      metis.model = gpt;
      # metis.variant = "max";
      momus.model = gpt;
      # momus.variant = "max";
      atlas.model = gpt;
      # atlas.variant = "xhigh";
    };
    categories = {
      visual-engineering.model = glmVision;
      ultrabrain.model = gpt;
      # ultrabrain.variant = "xhigh";
      deep.model = gpt;
      # deep.variant = "xhigh";
      artistry.model = glm;
      quick.model = glmFlash;
      unspecified-low.model = glm;
      unspecified-high.model = glm;
      # unspecified-high.variant = "xhigh";
      writing.model = glm;
    };
  };
}
