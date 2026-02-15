{ ... }:
let
  port = "9696";
in
{
  services.prowlarr = {
    enable = true;
  };
  services.nginx.virtualHosts."prowlarr.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
}
