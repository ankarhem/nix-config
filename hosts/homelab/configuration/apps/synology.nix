{ ... }: {
  services.nginx.virtualHosts."synology.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = { proxyPass = "https://192.168.1.163:5001"; };
  };
}
