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
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
    };
  };
}

