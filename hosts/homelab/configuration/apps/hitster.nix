{ config, ... }:
let port = "7033";
in {
  sops.secrets = {
    "spotify/client_id" = { };
    "spotify/client_secret" = { };
  };

  sops.templates."hitster.env" = {
    content = ''
      SPOTIFY_CLIENT_ID=${config.sops.placeholder."spotify/client_id"}
      SPOTIFY_CLIENT_SECRET=${config.sops.placeholder."spotify/client_secret"}
    '';
  };

  services.nginx.virtualHosts."hitster.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = { proxyPass = "http://127.0.0.1:${port}"; };
  };
  virtualisation.oci-containers = {
    autoUpdater.containers.hitster.enable = true;
    containers = {
      hitster = {
        image = "ghcr.io/ankarhem/hitster:latest";
        ports = [ "127.0.0.1:${port}:3000" ];
        environmentFiles = [ config.sops.templates."hitster.env".path ];
        volumes = [ "/var/lib/hitster/db:/data/db" ];
      };
    };
  };
}

