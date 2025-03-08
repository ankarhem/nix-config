{ ... }:
{
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
        PS_SHARED_SECRET= "redacted";
      };
      cmd = [
        "-db" "/data/store.db"
      ];
    };
  };
}

