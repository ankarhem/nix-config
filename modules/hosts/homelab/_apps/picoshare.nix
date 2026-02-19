{ config, ... }:
let
  port = "4001";
in
{
  sops.secrets."picoshare/shared_secret" = { };
  sops.templates."picoshare.env".content = ''
    PS_SHARED_SECRET=${config.sops.placeholder."picoshare/shared_secret"}
  '';

  services.nginx.virtualHosts."pico.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    extraConfig = ''
      client_max_body_size 100M;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
  virtualisation.oci-containers.containers = {
    picoshare = {
      image = "mtlynch/picoshare:latest";
      ports = [ "127.0.0.1:${port}:${port}" ];
      volumes = [ "/mnt/DISKETTEN_drive/picoshare:/data" ];
      environment = {
        PORT = port;
      };
      environmentFiles = [ config.sops.templates."picoshare.env".path ];
      cmd = [
        "-db"
        "/data/store.db"
      ];
    };
  };
}
