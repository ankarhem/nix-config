{ ... }:
let
  port = 8181;
in {
  services.tautulli = {
    enable = true;
    openFirewall = true;
    inherit port;
  };

  services.nginx.virtualHosts."tautulli.internetfeno.men" =  {
    forceSSL = true;
    useACMEHost = "internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
    };
  };
}

