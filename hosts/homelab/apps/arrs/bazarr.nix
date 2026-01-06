{ config, ... }:
{
  services.bazarr = {
    enable = true;
  };

  services.nginx.virtualHosts."bazarr.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString config.services.bazarr.listenPort}";
      proxyWebsockets = true;
    };
  };
}
