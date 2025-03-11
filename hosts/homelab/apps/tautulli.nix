{ ... }:
let
  port = 8181;
in {
  services.tautulli = {
    enable = true;
    openFirewall = true;
    inherit port;
  };

  services.nginx.virtualHosts."tautulli.internal.internetfeno.men" =  {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
    };
  };
}

