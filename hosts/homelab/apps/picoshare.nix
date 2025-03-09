{ config, ... }:
{
  sops.secrets.picoshare_env = {
    sopsFile = ../../../secrets/homelab/picoshare.env;
    format = "dotenv";
  };

  services.nginx.virtualHosts."pico.ankarhem.dev" =  {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:4001";
    };
  };
  virtualisation.oci-containers.containers = {
    picoshare = {
      image = "mtlynch/picoshare:latest";
      ports = ["127.0.0.1:4001:4001"];
      volumes = [
        "/mnt/DISKETTEN_drive/picoshare:/data"
      ];
      environment = {
        PORT = "4001";
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

