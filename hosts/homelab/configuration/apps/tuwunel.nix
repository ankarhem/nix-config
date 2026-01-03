{ self, config, ... }:
let
  port = 6167;
  domain = "matrix.internetfeno.men";
in
{
  # Nginx
  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";

    extraConfig = ''
      listen 8448 ssl http2 default_server;
      client_max_body_size 500M;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };

  sops.secrets."tuwunel/registration_token" = {
    owner = "tuwunel";
  };
  services.matrix-tuwunel = {
    enable = true;

    stateDirectory = "tuwunel";
    settings = {
      global = {
        address = [ "127.0.0.1" ];
        port = [ port ];
        server_name = domain;

        # Federation
        well_known = {
          server = "${domain}:443";
          client = "https://${domain}";
        };
        trusted_servers = [
          "matrix.org"
        ];
        # unix_socket_path = "/run/tuwunel/tuwunel.sock";
        # unix_socket_perms = 660;

        # Registration
        allow_registration = true;
        new_user_displayname_suffix = "👋";
        registration_token_file = config.sops.secrets."tuwunel/registration_token".path;
        forbidden_usernames = [
          "administrator"
          "admin"
        ];

        # Features
        allow_encryption = true;
        allow_federation = true;
        max_request_size = 104857600; # ~100 MB
        require_auth_for_profile_requests = true;
        suppress_push_when_active = true;

        # Backups
        database_backup_path = "/mnt/DISKETTEN_drive/tuwunel/backups";
      };
    };
  };

  sops.secrets."mautrix-telegram.env" = {
    owner = "mautrix-telegram";
    group = "mautrix-telegram";
    sopsFile = "${self}/secrets/homelab/mautrix-telegram.env";
    format = "dotenv";
  };

  # temporary allow olm-3.2.16 as insecure package
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-telegram.env".path;
    settings = {
      homeserver = {
        address = "http://127.0.0.1:${toString port}";
        inherit domain;
      };
      appservice = {
        address = "http://127.0.0.1:29317";
        hostname = "127.0.0.1";
        port = "29317";
        bot_username = "telegrambot";
      };
      bridge = {
        username_template = "telegram_{userid}";
        alias_template = "telegram_{groupname}";
        displayname_template = "{displayname} (Telegram)";
        permissions = {
          "*" = "relaybot";
          "matrix.org" = "user";
          "${domain}" = "full";
          "@admin:${domain}" = "admin";
        };
      };
    };
  };
}
