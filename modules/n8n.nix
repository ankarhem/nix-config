{ ... }:
let
  domain = "n8n.ankarhem.dev";
in
{
  flake.modules.nixos.n8n =
    { config, ... }:
    {
      sops.secrets."n8n/encryption_key" = { };

      services.n8n = {
        enable = true;
        environment = {
          N8N_HOST = domain;
          N8N_PORT = 5678;
          N8N_PROTOCOL = "https";
          N8N_LISTEN_ADDRESS = "127.0.0.1";
          N8N_WEBHOOK_URL = "https://${domain}";
          N8N_ENCRYPTION_KEY_FILE = config.sops.secrets."n8n/encryption_key".path;
        };
      };

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        extraConfig = ''
          client_max_body_size 50M;
          proxy_read_timeout 300s;
          proxy_connect_timeout 75s;
        '';
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString config.services.n8n.environment.N8N_PORT}";
        };
      };
    };
}
