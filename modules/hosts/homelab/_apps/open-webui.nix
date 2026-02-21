{ config, pkgs, ... }:
let
  domain = "ai.ankarhem.dev";
in
{
  sops.secrets = {
    "mcp_tokens/glm" = { };
    "open-webui/admin_password" = { };
  };

  sops.templates."open-webui.env".content = ''
    WEBUI_ADMIN_PASSWORD=${config.sops.placeholder."open-webui/admin_password"}
    OPENAI_API_KEYS=${config.sops.placeholder."mcp_tokens/glm"}
  '';

  services.open-webui = {
    enable = true;
    package = pkgs._unstable.open-webui;
    host = "127.0.0.1";
    port = 15867;
    environment = {
      # Core settings
      WEBUI_URL = "https://${domain}";
      WEBUI_NAME = "AI Chat";
      ENV = "prod";
      # DATA_DIR = "/mnt/DISKETTEN_drive/open-webui";

      OPENAI_API_BASE_URLS = "https://api.z.ai/api/coding/paas/v4";
      ENABLE_WEB_SEARCH = "True";
      WEB_SEARCH_ENGINE = "searxng";

      # Auth settings
      WEBUI_ADMIN_NAME = "Jakob Ankarhem";
      WEBUI_ADMIN_EMAIL = "jakob@ankarhem.dev";
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
