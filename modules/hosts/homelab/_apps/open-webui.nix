{ config, ... }:
let
  domain = "ai.ankarhem.dev";
in
{
  sops.secrets = {
    "mcp_tokens/glm" = { };
    "open-webui/admin_password" = { };
  };

  sops.templates."open-webui.env".content = ''
    WEBUI_ADMIN_EMAIL = "jakob@ankarhem.dev";
    WEBUI_ADMIN_PASSWORD=${config.sops.placeholder."open-webui/admin_password"}

    # 1. GLM (z.ai) semicolon separated list
    OPENAI_API_BASE_URLS = "https://api.z.ai/api/coding/paas/v4";
    OPENAI_API_KEYS=${config.sops.placeholder."mcp_tokens/glm"}
  '';

  services.open-webui = {
    enable = true;
    host = "127.0.0.1";
    port = 8080;
    stateDir = "/mnt/DISKETTEN_drive/open-webui";
    environment = {
      # Core settings
      WEBUI_URL = "https://${domain}";
      WEBUI_NAME = "AI Chat";
      ENV = "prod";

      # Auth settings
      ENABLE_SIGNUP = "False";

      # Privacy
      SCARF_NO_ANALYTICS = "True";
      DO_NOT_TRACK = "True";
      ANONYMIZED_TELEMETRY = "False";
    };
    environmentFile = config.sops.templates."open-webui.env".path;
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    extraConfig = ''
      proxy_read_timeout 300s;
      proxy_connect_timeout 75s;
    '';
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${toString config.services.open-webui.port}";
    };
  };
}
