{...}:{
  services.nginx.virtualHosts."synology.internal.internetfeno.men" =  {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "https://127.0.0.1:5001";
    };
  };
}
