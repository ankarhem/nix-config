{
  lib,
  pkgs,
  self,
  config,
  username,
  pkgs-unstable,
  ...
}:
let
  nodejs_lts = pkgs-unstable.nodejs_24;

  claude-with-secrets = pkgs-unstable.writeShellApplication {
    name = "claude";
    runtimeInputs = [ pkgs-unstable.claude-code ];
    text = ''
      # shellcheck disable=SC1091
      source ${config.sops.templates."claude.env".path}
      exec claude "$@"
    '';
  };
  happy-coder = pkgs.callPackage "${self}/packages/happy-coder.nix" { };
in
{
  sops = {
    secrets = {
      "glm_token" = {
        owner = username;
        sopsFile = "${self}/secrets/shared.yaml";
      };
      "context7_token" = {
        owner = username;
        sopsFile = "${self}/secrets/shared.yaml";
      };
      "devin_token" = {
        owner = username;
        sopsFile = "${self}/secrets/shared.yaml";
      };
    };

    templates."claude.env" = {
      owner = username;
      content = ''
        ANTHROPIC_AUTH_TOKEN=${config.sops.placeholder.glm_token}
        CONTEXT7_TOKEN=${config.sops.placeholder.context7_token}
        DEVIN_TOKEN=${config.sops.placeholder.devin_token}
      '';
    };
  };

  # This is for summarize binary
  programs.fish.shellInit = ''
    set -x ANTHROPIC_AUTH_TOKEN "$(cat ${config.sops.secrets.glm_token.path})"
  '';

  home-manager.users."${username}" = {
    home.packages = [
      happy-coder
    ];

    programs.claude-code = {
      enable = true;
      package = claude-with-secrets;

      settings = {
        alwaysThinkingEnabled = true;
        env = {
          ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
          API_TIMEOUT_MS = "3000000";
          ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.7";
          ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.7";
          ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air";
        };
      };
      mcpServers = {
        playwrite = {
          type = "stdio";
          command = "${nodejs_lts}/bin/npx";
          args = [ "@playwright/mcp@latest" ];
        };
        sequential-thinking = {
          type = "stdio";
          command = "${nodejs_lts}/bin/npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-sequential-thinking"
          ];
        };
        mcp-nixos = {
          type = "stdio";
          command = "nix";
          args = [
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
        ms-learn = {
          type = "http";
          url = "https://learn.microsoft.com/api/mcp";
        };
        context7 = {
          type = "http";
          url = "https://mcp.context7.com/mcp";
          headers.Authorization = "Bearer \${CONTEXT7_TOKEN}";
        };
        atlassian = {
          type = "sse";
          url = "https://mcp.atlassian.com/v1/sse";
        };
        devin-wiki = {
          type = "http";
          url = "https://mcp.devin.ai/mcp";
          headers.Authorization = "Bearer \${DEVIN_TOKEN}";
        };
        # github = {
        #   type = "http";
        #   url = "https://api.githubcopilot.com/mcp";
        # };
      };
    };
  };
}
