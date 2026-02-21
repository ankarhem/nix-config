_: {
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
      sisyphus = {
        model = "anthropic/claude-sonnet-4-6";
        variant = "max";
        ultrawork = {
          model = "anthropic/claude-opus-4-6";
          variant = "max";
        };
      };
      hephaestus = {
        model = "openai/gpt-5.3-codex";
        variant = "medium";
      };
      oracle = {
        model = "openai/gpt-5.2";
        variant = "high";
      };
      librarian.model = "zai-coding-plan/glm-4.7";
      explore.model = "anthropic/claude-haiku-4-5";
      multimodal-looker.model = "google/gemini-3-flash";
      prometheus = {
        model = "anthropic/claude-opus-4-6";
        variant = "max";
      };
      metis = {
        model = "anthropic/claude-opus-4-6";
        variant = "max";
      };
      momus = {
        model = "openai/gpt-5.2";
        variant = "medium";
      };
      atlas.model = "anthropic/claude-sonnet-4-6";
    };
    categories = {
      visual-engineering = {
        model = "google/gemini-3-pro";
        variant = "high";
      };
      ultrabrain = {
        model = "openai/gpt-5.3-codex";
        variant = "xhigh";
      };
      deep = {
        model = "openai/gpt-5.3-codex";
        variant = "medium";
      };
      artistry = {
        model = "google/gemini-3-pro";
        variant = "high";
      };
      quick.model = "anthropic/claude-haiku-4-5";
      unspecified-low.model = "anthropic/claude-sonnet-4-6";
      unspecified-high.model = "anthropic/claude-sonnet-4-6";
      writing.model = "google/gemini-3-flash";
    };
  };
}
