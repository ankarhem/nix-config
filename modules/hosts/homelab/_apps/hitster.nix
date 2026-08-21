{ config, ... }:
let
  port = "7033";
  domain = "hitster.ankarhem.dev";
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
    '';
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };

  systemd.services.hitster =
    let
      profile = "/nix/var/nix/profiles/per-user/root/hitster";
      binary = "${profile}/bin/hitster";
    in
    {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      unitConfig.ConditionPathExists = binary;
      serviceConfig = {
        ExecStart = binary;
        WorkingDirectory = "/var/lib/hitster";
        StateDirectory = "hitster";
        Restart = "always";
        RestartSec = "5s";
        EnvironmentFile = config.sops.templates."hitster.env".path;
      };
      environment = {
        BASE_URL = "https://${domain}";
        BIND_PORT = port;
      };
    };
}
