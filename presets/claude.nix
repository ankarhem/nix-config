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
      set -a
      # shellcheck disable=SC1091
      source ${config.sops.templates."claude.env".path}
      unset ANTHROPIC_AUTH_TOKEN
      set +a
      exec claude "$@"
    '';
  };

  mcpConfig = (pkgs.formats.json { }).generate "claude-code-mcp-config.json" {
    inherit (config.home-manager.users.${username}.programs.claude-code) mcpServers;
  };
  glm-with-secrets = pkgs.writeShellApplication {
    name = "claude-glm";
    runtimeInputs = [ pkgs-unstable.claude-code ];
    text = ''
      set -a
      # shellcheck disable=SC1091
      source ${config.sops.templates."claude.env".path}
      # shellcheck disable=SC1091
      source ${config.sops.templates."glm.env".path}
      set +a
      # We need to inject the mcp configuration (as is done internally for the package passed to programs.claude-code).
      exec claude --mcp-config ${mcpConfig} "$@"
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
        CONTEXT7_TOKEN=${config.sops.placeholder.context7_token}
        DEVIN_TOKEN=${config.sops.placeholder.devin_token}
      '';
    };

    templates."glm.env" = {
      owner = username;
      content = ''
        ANTHROPIC_AUTH_TOKEN=${config.sops.placeholder.glm_token}
        ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
        ANTHROPIC_DEFAULT_OPUS_MODEL="GLM-4.7"
        ANTHROPIC_DEFAULT_SONNET_MODEL="GLM-4.7"
        ANTHROPIC_DEFAULT_HAIKU_MODEL="GLM-4.5-Air"
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
      glm-with-secrets
    ];

  };
}
