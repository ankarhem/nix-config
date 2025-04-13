{ self, config, pkgs, ... }:
let port = 8083;
in {
  sops.secrets.lk_jwt_env = {
    sopsFile = "${self}/secrets/homelab/lk-jwt.env";
    format = "dotenv";
  };
  systemd.services.lk-jwt-service = {
    description = "Minimal service to issue LiveKit JWTs for MatrixRTC";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lk-jwt-service}/bin/lk-jwt-service";
      Restart = "always";
      RestartSec = "5";
      User = "lk-jwt-service";
      Group = "lk-jwt-service";
      EnvironmentFile = config.sops.secrets.lk_jwt_env.path;
    };

    environment = {
      LIVEKIT_URL = "wss://${config.meenzen.livekit.domain}";
      LIVEKIT_JWT_PORT = toString port;
    };
  };

  users.users.lk-jwt-service = {
    isSystemUser = true;
    group = "lk-jwt-service";
    description = "lk-jwt-service service user";
  };

  users.groups.lk-jwt-service = { };

  services.nginx.virtualHosts."livekit-jwt.internetfeno.men" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
  };
}
