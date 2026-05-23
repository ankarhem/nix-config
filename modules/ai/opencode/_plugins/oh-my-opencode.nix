{ pkgs, ... }:
let
  # gpt = "openai/gpt-5.5-fast";

  glm = "synthetic/hf:zai-org/GLM-5.1";
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
      hephaestus.model = glm;
      oracle.model = opus;
      librarian.model = glmFlash;
      explore.model = glmFlash;
      multimodal-looker.model = glmVision;
      prometheus.model = opus;
      metis.model = opus;
      momus.model = opus;
      atlas.model = glm;
    };
    categories = {
      visual-engineering.model = glmVision;
      ultrabrain.model = opus;
      deep.model = glm;
      artistry.model = glm;
      quick.model = glmFlash;
      unspecified-low.model = glmFlash;
      unspecified-high.model = glm;
      writing.model = glm;
    };
  };
}
