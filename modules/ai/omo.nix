{ inputs, ... }:
let
  glmFlash = {
    model = "zai/glm-5.3-flash";
    reasoning = "max";
  };

  glm = {
    model = "zai/glm-5.3";
    reasoning = "max";
  };

  opus = "claude-sdk-oauth/claude-opus-5";
  opusLow = {
    model = "claude-sdk-oauth/claude-opus-5";
    reasoning = "low";
  };
  fable = "claude-sdk-oauth/claude-fable-5-1";
  museFree = "opencode/muse-spark-1.3-contributor-free";
in
{
  flake.modules.homeManager.omo =
    {
      pkgs,
      config,
      ...
    }:
    let
      llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      omo-upstream = llmAgents.omo-ai;
      # Upstream omo-ai does not ship direnv on PATH; the vendored
      # pi-direnv extension shells out to `direnv export json`, so keep
      # the guarantee the old local package provided.
      omo-ai = pkgs.symlinkJoin {
        name = "omo-ai";
        paths = [ omo-upstream ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/omo \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.direnv ]}
        '';
      };
      herdr = llmAgents.herdr;
    in
    {
      home.packages = [
        omo-ai
        herdr
      ];
      home.file.".omo/agent/AGENTS.md".source = ./opencode/language.md;

      sops.secrets."mcp_tokens/exa" = { };
      sops.secrets."mcp_tokens/tavily" = { };
      sops.secrets."mcp_tokens/brave" = { };
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
                "provider": "brave",
                "apiKey": "${config.sops.placeholder."mcp_tokens/brave"}",
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
        force = true;
        text = builtins.toJSON {
          "$schema" =
            "https://raw.githubusercontent.com/code-yeongyu/oh-my-openagent/dev/assets/omo.schema.json";
          _migrations = [
            "2026-07-opencode-config-unification"
            "2026-07-codex-config-jsonc"
          ];
          git_master = {
            commit_footer = true;
            include_co_authored_by = true;
          };
          retry = {
            provider.minThroughputTokensPerSecond = 0;
            fallbackChains = {
              "zai/glm-5.3" = [
                opus
                museFree
              ];
              "zai/glm-5.3-flash" = [
                opus
                museFree
              ];
            };
          };
          task.team = {
            max_members = 8;
            max_parallel_members = 4;
            max_wall_clock_minutes = 120;
          };
          # Goal + browser engine live under the [opencode] scope; this is
          # the Native (senpi) edition, so they do not apply here.
          # browser_automation_engine.provider = "agent-browser";
          # goal = {
          #   enabled = true;
          #   default_max_iterations = 25;
          # };
          agents = {
            # Built-in agents
            explore = {
              models = [
                glmFlash
                opusLow
              ];
            };
            librarian = {
              models = [
                glmFlash
                opusLow
              ];
            };
            plan-consultant = {
              models = [
                fable
                opus
                glm
              ];
            };
            plan-reviewer = {
              models = [
                fable
                opus
                glm
              ];
            };
            # Custom agents
            oracle = {
              models = [
                fable
                opus
                glm
              ];
            };
            oracle-free = {
              models = [
                {
                  model = museFree;
                  reasoning = "xhigh";
                }
              ];
            };
          };
          categories = {
            # Built-in categories
            architect = {
              models = [
                fable
                opus
                glm
              ];
            };
            artistry = {
              models = [
                glmFlash
                opus
              ];
            };
            deep = {
              models = [
                glm
                opus
              ];
            };
            quick = {
              models = [
                glmFlash
                opus
              ];
            };
            ultrabrain = {
              models = [
                opus
                glm
              ];
            };
            unspecified-high = {
              models = [
                opus
                glm
              ];
            };
            unspecified-low = {
              models = [
                glmFlash
                opus
              ];
            };
            visual-engineering = {
              models = [
                glmFlash
                opus
              ];
            };
            writing = {
              models = [
                glmFlash
                opusLow
              ];
            };
          };
        };
      };
    };
}
