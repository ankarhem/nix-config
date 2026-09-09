{ inputs, ... }:
let
  glmFlash = "zai-coding-plan/glm-5.3-flash";

  glm = "zai-coding-plan/glm-5.3";

  opus = "anthropic/claude-opus-5";
  sonnet = "anthropic/claude-sonnet-5";
  fable = "anthropic/claude-fable-5-1";
in
{
  flake.modules.homeManager.omo =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.local.omo-ai
      ];
      home.file.".omo/agent/AGENTS.md".source = ./opencode/language.md;
      # Vendored pi-direnv extension (see the file header for provenance);
      # senpi auto-discovers extensions in ~/.omo/agent/extensions/.
      home.file.".omo/agent/extensions/pi-direnv.ts".source = ./omo/pi-direnv.ts;
      home.file.".omo/omo.jsonc" = {
        # omo's own 2026-07-opencode-config-unification migration already created
        # this file; take it over from nix.
        force = true;
        text = builtins.toJSON {
          "$schema" =
            "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json";
          # omo.jsonc is a read-only nix store symlink, so omo can never write its
          # own migration markers into it; without these it re-runs the migrations
          # on every startup (and fails validating the unknown keys below).
          _migrations = [
            "2026-07-opencode-config-unification"
            "2026-07-codex-config-jsonc"
          ];
          git_master = {
            commit_footer = true;
            include_co_authored_by = true;
          };
          task.team = {
            max_members = 8;
            max_parallel_members = 4;
            max_wall_clock_minutes = 120;
          };
          # Not in any released omo schema yet (checked beta.48/51 + dev branch);
          # uncomment when omo accepts them.
          # browser_automation_engine.provider = "agent-browser";
          # goal = {
          #   enabled = true;
          #   default_max_iterations = 25;
          # };
          agents = {
            sisyphus = {
              models = [
                glm
                sonnet
              ];
            };
            sisyphus-junior = {
              models = [
                glm
                sonnet
              ];
            };
            # hephaestus = {
            #   model = glm;
            # };
            oracle = {
              models = [
                fable
                opus
                glm
              ];
            };
            librarian = {
              models = [
                glmFlash
                sonnet
              ];
            };
            explore = {
              models = [
                glmFlash
                sonnet
              ];
            };
            multimodal-looker = {
              models = [
                glmFlash
                sonnet
              ];
            };
            prometheus = {
              models = [
                fable
                opus
                glm
              ];
            };
            metis = {
              models = [
                opus
                glm
              ];
            };
            momus = {
              models = [
                opus
                glm
              ];
            };
            atlas = {
              models = [
                glm
                sonnet
              ];
            };
          };
          categories = {
            visual-engineering = {
              models = [
                glmFlash
                sonnet
              ];
            };
            ultrabrain = {
              models = [
                opus
                glm
              ];
            };
            deep = {
              models = [
                glm
                sonnet
              ];
            };
            artistry = {
              models = [
                glmFlash
                sonnet
              ];
            };
            quick = {
              models = [
                glmFlash
                sonnet
              ];
            };
            unspecified-low = {
              models = [
                glmFlash
                sonnet
              ];
            };
            unspecified-high = {
              models = [
                opus
                glm
              ];
            };
            writing = {
              models = [
                glmFlash
                sonnet
              ];
            };
          };
        };
      };
    };
}
