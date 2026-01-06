{ config, ... }:
let
  port = "7033";
in
{
  sops.secrets = {
    "spotify/client_id" = { };
    "spotify/client_secret" = { };
  };

  sops.templates."hitster.env" = {
    content = ''
      SPOTIFY_CLIENT_ID=${config.sops.placeholder."spotify/client_id"}
      SPOTIFY_CLIENT_SECRET=${config.sops.placeholder."spotify/client_secret"}

      HITSTER_SPOTIFY__CLIENT_ID=${config.sops.placeholder."spotify/client_id"}
      HITSTER_SPOTIFY__CLIENT_SECRET=${config.sops.placeholder."spotify/client_secret"}
    '';
  };

  services.nginx.virtualHosts."hitster.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
  virtualisation.oci-containers = {
    containers = {
      hitster = {
        image = "ghcr.io/ankarhem/hitster:latest";
        ports = [ "127.0.0.1:${port}:3000" ];
        environment = {
          HITSTER_SERVER__HOST = "0.0.0.0";
        };
        environmentFiles = [ config.sops.templates."hitster.env".path ];
        volumes = [
          "/var/lib/hitster/db:/data/db"
          "/var/lib/hitster/config:/config"
        ];
      };
    };
  };
}
