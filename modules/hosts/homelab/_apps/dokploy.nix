{ ... }:
let
  port = "3000";
in
{
  services.nginx.virtualHosts."dokploy.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://dokploy.local:${port}";
    };
  };
  services.nginx.virtualHosts."*.hub.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "hub.internetfeno.men";
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://dokploy.local";
    };
  };
}
