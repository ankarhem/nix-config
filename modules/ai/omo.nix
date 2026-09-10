{ inputs, ... }:
let
  glmFlash = "zai/glm-5.3-flash";

  glm = "zai/glm-5.3";

  opus = "claude-sdk-oauth/claude-opus-5";
  sonnet = "claude-sdk-oauth/claude-sonnet-5";
  fable = "claude-sdk-oauth/claude-fable-5-1";
in
{
  flake.modules.homeManager.omo =
    {
      pkgs,
      config,
      ...
    }:
    {
      home.packages = [
        pkgs.local.omo-ai
      ];
      home.file.".omo/agent/AGENTS.md".source = ./opencode/language.md;
      # Senpi websearch routing (strategy/priority/fallback per the engine's
      # builtin websearch extension). Rendered via sops so the apiKeys never
      # land in the world-readable nix store. omo loads it at session start;
      # restart omo after switch. `/websearch status` shows the live routing.
      # z-ai reuses the existing mcp_tokens/glm key (same api.z.ai Bearer
      # scheme); exa uses the mcp_tokens/exa key from secrets.yaml.
      sops.secrets."mcp_tokens/exa" = { };
      sops.secrets."mcp_tokens/tavily" = { };
      # Rendered straight to ~/.omo/websearch.json at activation (NOT via
      # home.file.source: the rendered path lives outside the store, which
      # pure evaluation forbids reading at build time).
      sops.templates."websearch.json" = {
        path = "${config.home.homeDirectory}/.omo/websearch.json";
        content = ''
          {
            "strategy": "priority",
            "fallback": true,
            "auto": false,
            "providers": [
              {
                "provider": "z-ai",
                "apiKey": "${config.sops.placeholder."mcp_tokens/glm"}",
                "maxResults": 10
              },
              {
                "provider": "exa",
                "apiKey": "${config.sops.placeholder."mcp_tokens/exa"}",
                "maxResults": 10
              },
              {
                "provider": "tavily",
                "apiKey": "${config.sops.placeholder."mcp_tokens/tavily"}",
                "maxResults": 10
              },
              {
                "provider": "duckduckgo-html",
                "maxResults": 10
              }
            ]
          }
        '';
      };
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
