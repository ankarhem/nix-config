{ config, ... }:
let
  port = 4001;
in
{
  sops.secrets.picoshare_env = {
    sopsFile = ../../../secrets/homelab/picoshare.env;
    format = "dotenv";
  };

  services.nginx.virtualHosts."pico.ankarhem.dev" =  {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };
  virtualisation.oci-containers.containers = {
    picoshare = {
      image = "mtlynch/picoshare:latest";
      ports = ["127.0.0.1:${toString port}:${toString port}"];
      volumes = [
        "/mnt/DISKETTEN_drive/picoshare:/data"
      ];
      environment = {
        PORT = toString port;
      };
      environmentFiles = [
        config.sops.secrets.picoshare_env.path
      ];
      cmd = [
        "-db" "/data/store.db"
      ];
    };
  };
}

