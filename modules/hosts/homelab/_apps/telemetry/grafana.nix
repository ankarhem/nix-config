{ config, ... }:
{
  sops.secrets."grafana/secret_key" = {
    owner = config.services.grafana.user;
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 2342;
        domain = "grafana.internal.internetfeno.men";
      };
      security.secret_key = "$__file{${config.sops.secrets."grafana/secret_key".path}}";
    };
  };
  services.nginx.virtualHosts.${config.services.grafana.settings.server.domain} = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
    };
  };
}
