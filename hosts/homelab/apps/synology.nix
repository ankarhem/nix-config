{...}:{
  services.nginx.virtualHosts."synology.internal.internetfeno.men" =  {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "https://disketten.local:5001";
    };
  };
}
