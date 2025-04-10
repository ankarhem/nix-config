{ ... }:
let port = "8989";
in {
  services.sonarr = { enable = true; };
  services.nginx.virtualHosts."sonarr.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
      proxyWebsockets = true;
    };
  };
}
