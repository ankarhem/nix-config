{ ... }:
let port = "3000";
in {
  services.nginx.virtualHosts."dokploy.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = { proxyPass = "http://dokploy.local:${port}"; };
  };
}

