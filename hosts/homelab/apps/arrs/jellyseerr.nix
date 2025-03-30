{config, ...}: {

  # redirect overseerr to jellyseerr
  services.nginx.virtualHosts."overseerr.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";
    extraConfig = ''
      return 301 https://jellyseerr.internetfeno.men$request_uri;
    '';
  };
  services.nginx.virtualHosts."jellyseerr.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.jellyseerr.port}";
    };
  };

  services.jellyseerr = {
    enable = true;
    port = 5055;
  };
}
