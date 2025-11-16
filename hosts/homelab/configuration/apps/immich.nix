{ config, ... }:
let domain = "photos.ankarhem.dev";

in {
  sops.secrets = {
    "immich/db_password" = { };
    "immich/redis_password" = { };
  };

  sops.templates."immich.env" = {
    content = ''
      DB_PASSWORD=${config.sops.placeholder."immich/db_password"}
    '';
  };
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    mediaLocation = "/mnt/DISKETTEN_drive/immich";
    secretsFile = config.sops.templates."immich.env".path;
    # null will give access to all devices.
    accelerationDevices = null;
    settings = {
      server.externalDomain = "https://${domain}";
      notifications.smtp = {
        enabled = false;
        from = "admin@ankarhem.dev";
        replyTo = "noreply@ankarhem.dev";
        transport = { host = "smtp.mail.me.com"; };
      };
    };
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    extraConfig = ''
      client_max_body_size 5000M;
      proxy_read_timeout 600s;
      proxy_send_timeout 600s;
      send_timeout       600s;
    '';
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${toString config.services.immich.port}";
    };
  };
}
