{ lib, pkgs, ... }:
let
  gptCodex = "openai/gpt-5.3-codex";
  gpt = "openai/gpt-5.3";

  glm = "zai-coding-plan/glm-5";
  glmFlash = "zai-coding-plan/glm-4.7-flash";
in
{
  programs.opencode.settings = {
    plugin = [
      "oh-my-opencode"
    ];
  };

  home.file.".config/opencode/oh-my-opencode.json".text = builtins.toJSON {
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
      hephaestus.model = gptCodex;
      oracle.model = gpt;
      librarian.model = glm;
      explore.model = glmFlash;
      multimodal-looker.model = gpt;
      prometheus.model = gptCodex;
      metis.model = gpt;
      momus.model = gpt;
      atlas.model = gptCodex;
    };
    categories = {
      visual-engineering.model = gptCodex;
      ultrabrain.model = gptCodex;
      deep.model = gptCodex;
      artistry.model = gptCodex;
      quick.model = glmFlash;
      unspecified-low.model = glm;
      unspecified-high.model = gptCodex;
      writing.model = glm;
    };
    lsp = {
      omnisharp = {
        command = [
          (lib.getExe pkgs.omnisharp-roslyn)
        ];
        extensions = [ ".cs" ];
        priority = 100;
        initializationOptions = { };
      };
    };
  };
}
