{
  self,
  config,
  username,
  pkgs-unstable,
  ...
}:
let
  wrapped-claude = pkgs-unstable.writeShellApplication {
    name = "claude";
    runtimeInputs = [ pkgs-unstable.claude-code ];
    text = ''
      ANTHROPIC_AUTH_TOKEN="$(cat ${config.sops.secrets.glm_token.path})"
      export ANTHROPIC_AUTH_TOKEN
      exec claude "$@"
    '';
  };
in
{
  sops.secrets."glm_token" = {
    owner = username;
    sopsFile = "${self}/secrets/shared.yaml";
    format = "yaml";
  };

  # until scripts have a module to pass stuff in to
  programs.fish.shellInit = ''
    set -x ANTHROPIC_AUTH_TOKEN "$(cat ${config.sops.secrets.glm_token.path})"
  '';

  home-manager.users."${username}" = {
    programs.claude-code = {
      enable = true;
      package = wrapped-claude;

      settings = {
        env = {
          ANTHROPIC_BASE_URL = "https://api.z.ai/api/anthropic";
          API_TIMEOUT_MS = "3000000";
          ANTHROPIC_DEFAULT_OPUS_MODEL = "GLM-4.7";
          ANTHROPIC_DEFAULT_SONNET_MODEL = "GLM-4.7";
          ANTHROPIC_DEFAULT_HAIKU_MODEL = "GLM-4.5-Air";
        };
      };
    };
  };
}
