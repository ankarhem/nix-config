{ ... }:
let
  port = "4002";
in
{
  services.nginx.virtualHosts."swerdle.ankarhem.dev" =  {
    forceSSL = true;
    enableACME = true;
    serverAliases = [
      "swerdle.internetfeno.men"
    ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
  virtualisation.oci-containers.containers = {
    swerdle = {
      image = "ghcr.io/ankarhem/swerdle:master";
      ports = ["127.0.0.1:${port}:3000"];
      volumes = [
        "/var/lib/swerdle:/usr/src/app/db"
      ];
    };
  };
}

