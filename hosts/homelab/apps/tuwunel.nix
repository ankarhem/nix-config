{
  self,
  lib,
  config,
  pkgs-unstable,
  ...
}:
let
  port = 6167;
  domain = "matrix.internetfeno.men";

  defaultAppserviceConfig = {
    homeserver = {
      address = "http://127.0.0.1:${toString port}";
      inherit domain;
    };
    encryption = {
      allow = true;
      default = true;
      require = true;
      pickle_key = "$PICKLE_KEY";
      appservice = false;
      self_sign = true;
      delete_keys = {
        dont_store_outbound = true;
        ratchet_on_decrypt = true;
        delete_fully_used_on_decrypt = true;
        delete_prev_on_new_session = true;
        delete_on_device_delete = true;
        periodically_delete_expired = true;
        delete_outdated_inbound = true;
      };
    };
    bridge = {
      permissions = {
        "*" = "relay";
        "matrix.org" = "user";
        "${domain}" = "user";
        "@ankarhem:${domain}" = "admin";
        "@admin:${domain}" = "admin";
      };
    };
    # new syntax for login_shared_secret_map
    double_puppet = {
      servers = { };
      allow_discovery = false;
      secrets."${domain}" = "as_token:$DOUBLEPUPPET_AS_TOKEN";
    };
    backfill = {
      enabled = true;
      max_initial_messages = 50;
      max_catchup_messages = 500;
      # unread_hours_threshold = 720;
    };
  };
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
    package = pkgs-unstable.matrix-tuwunel;

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

  sops.secrets."mautrix-bridges.env" = {
    sopsFile = "${self}/secrets/homelab/mautrix-bridges.env";
    format = "dotenv";
  };

  # temporary allow olm-3.2.16 as insecure package
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-bridges.env".path;
    settings = lib.recursiveUpdate defaultAppserviceConfig {
      bridge = {
        login_shared_secret_map."${domain}" = "as_token:$DOUBLEPUPPET_AS_TOKEN";
        encryption = defaultAppserviceConfig.encryption;
      };
      appservice = {
        id = "telegram";
        as_token = "$MAUTRIX_TELEGRAM_APPSERVICE_AS_TOKEN";
        hs_token = "$MAUTRIX_TELEGRAM_APPSERVICE_HS_TOKEN";
        address = "http://127.0.0.1:29317";
        port = "29317";
        bot_username = "telegrambot";
        bot_displayname = "Telegram bridge bot";
        bot_avatar = "mxc://maunium.net/tJCRmUyJDsgRNgqhOgoiHWbX";
      };
    };
  };

  services.mautrix-meta = {
    instances = {
      instagram = {
        enable = true;
        environmentFile = config.sops.secrets."mautrix-bridges.env".path;
        settings = lib.recursiveUpdate defaultAppserviceConfig {
          network.mode = "instagram";
          appservice = {
            id = "instagrambot";
            as_token = "$MAUTRIX_INSTAGRAM_APPSERVICE_AS_TOKEN";
            hs_token = "$MAUTRIX_INSTAGRAM_APPSERVICE_HS_TOKEN";
            bot = {
              username = "instagrambot";
              displayname = "Instagram bridge bot";
            };
          };
        };
      };
      messenger = {
        enable = true;
        environmentFile = config.sops.secrets."mautrix-bridges.env".path;
        settings = lib.recursiveUpdate defaultAppserviceConfig {
          network.mode = "messenger";
          appservice = {
            id = "messengerbot";
            as_token = "$MAUTRIX_MESSENGER_APPSERVICE_AS_TOKEN";
            hs_token = "$MAUTRIX_MESSENGER_APPSERVICE_HS_TOKEN";
            bot = {
              username = "messengerbot";
              displayname = "Messenger bridge bot";
            };
          };
        };
      };
    };
  };

  services.mautrix-signal = {
    enable = true;
    environmentFile = config.sops.secrets."mautrix-bridges.env".path;
    settings = lib.recursiveUpdate defaultAppserviceConfig {
      appservice = {
        id = "signalbot";
        as_token = "$MAUTRIX_SIGNAL_APPSERVICE_AS_TOKEN";
        hs_token = "$MAUTRIX_SIGNAL_APPSERVICE_HS_TOKEN";
        bot = {
          username = "signalbot";
          displayname = "Signal bridge bot";
        };
      };
    };
  };
}
