{ self, config, ... }:
let
  port = 8448;
in
{
  # Nginx
  services.nginx.virtualHosts."matrix.internetfeno.men" = {
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
        server_name = "matrix.internetfeno.men";

        # Federation
        well_known = {
          server = "matrix.internetfeno.men:443";
          client = "https://matrix.internetfeno.men";
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
        database_backup_path = "/mnt/DISKETTEN_drive/conduwuit/backups";
      };
    };
  };

  # sops.secrets."mautrix-telegram.env" = {
  #   owner = "mautrix-telegram";
  #   group = "mautrix-telegram";
  #   sopsFile = "${self}/secrets/homelab/mautrix-telegram.env";
  # };
}
