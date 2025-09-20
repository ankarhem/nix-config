{ config, ... }: {
  services.nginx.virtualHosts."synology.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "https://${config.networking.custom.synologyIp}:5001";
    };
  };
}
