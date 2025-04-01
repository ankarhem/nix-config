{...}: let
  port = "7878";
in {
  services.radarr = {
    enable = true;
  };
  services.nginx.virtualHosts."radarr.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
      proxyWebsockets = true;
    };
  };
}
