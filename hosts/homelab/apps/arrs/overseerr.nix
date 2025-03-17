{...}: let
  port = 5055;
in {
  imports = [
    ../../../../nixosModules/services/overseerr.nix
  ];

  services.nginx.virtualHosts."overseerr.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };

  services.overseerr = {
    enable = true;
    inherit port;
  };
}
