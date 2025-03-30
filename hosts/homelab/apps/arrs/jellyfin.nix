{config, ...}:let
  port = 8096;
in {
  services.nginx.virtualHosts."jellyfin.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";

    extraConfig = ''
      send_timeout 100m;
      client_max_body_size 100M;
      proxy_redirect off;
      proxy_buffering off;
    '';

    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
      proxyWebsockets = true;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
