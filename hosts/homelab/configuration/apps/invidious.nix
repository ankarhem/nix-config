{ config, pkgs, ... }:
let
  companion = {
    port = 8282;
    domain = "invidious-companion.internal.internetfeno.men";
  };
in {
  nixpkgs.overlays = [
    (self: super: {
      invidious-master = pkgs.invidious.override {
        versions = {
          invidious = {
            hash = "sha256-u3ksHE4pBTmE4PI85lPcfr0kkx7un2V3fdY4hNn2KPM=";
            version = "2.20250502.0";
            date = "2025.05.02";
            commit = "7579adc";
            rev = "7579adc3a3f23958afc4f11c9c52302f9962f879";
          };
          videojs = {
            hash = "sha256-jED3zsDkPN8i6GhBBJwnsHujbuwlHdsVpVqa1/pzSH4";
          };
        };
      };
    })
  ];

  services.nginx.virtualHosts."${config.services.invidious.domain}" = {
    forceSSL = true;
    enableACME = false;
    useACMEHost = "internal.internetfeno.men";
  };
  services.nginx.virtualHosts."${companion.domain}" = {
    forceSSL = true;
    enableACME = false;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString companion.port}";
    };
  };

  users = {
    users."invidious" = {
      isSystemUser = true;
      group = "invidious";
    };
    groups."invidious" = { };
  };

  sops.secrets = {
    "invidious/hmac_key" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/db_pass" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/po_token" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/visitor_data" = {
      owner = "invidious";
      group = "invidious";
    };
    "invidious/companion_key" = { };
  };

  sops.templates."invidious_companion.env" = {
    content = ''
      SERVER_SECRET_KEY=${config.sops.placeholder."invidious/companion_key"}
      SERVER_BASE_URL=https://${companion.domain}
    '';
  };
  virtualisation.oci-containers.containers."invidious_companion" = {
    image = "quay.io/invidious/invidious-companion:latest";
    environmentFiles = [ config.sops.templates."invidious_companion.env".path ];
    volumes = [ "/var/lib/invidious/companion:/var/tmp/youtubei.js:rw" ];
    # capabilities = { ALL = false; };
    ports =
      [ "127.0.0.1:${toString companion.port}:${toString companion.port}" ];
  };
  services.invidious = {
    enable = true;
    package = pkgs.invidious-master;
    domain = "yt.internal.internetfeno.men";
    port = 4747;
    nginx.enable = true;
    sig-helper.enable = false;
    # sig-helper.package = pkgs-unstable.inv-sig-helper;
    # hmacKeyFile = config.sops.secrets."invidious/hmac_key".path;
    database.passwordFile = config.sops.secrets."invidious/db_pass".path;
    extraSettingsFile =
      config.sops.templates."invidious_extra_settings.json".path;
    settings = {
      domain = config.services.invidious.domain;
      https_only = true;
      dark_mode = "dark";
      default_home = "Subscriptions";
      default_user_preferences = {
        region = "SE";
        captions = [ "English" "English (auto-generated)" "Swedish" ];
        dark_mode = "dark";
        quality = "dash";
        local = true;
      };
      db = { user = "invidious"; };
      invidious_companion = [{
        private_url = "http://127.0.0.1:${toString companion.port}";
        public_url = "https://${companion.domain}";
      }];
    };
  };

  sops.templates."invidious_extra_settings.json" = {
    content = ''
      { "hmac_key": "${config.sops.placeholder."invidious/hmac_key"}" }
      { "po_token": "${config.sops.placeholder."invidious/po_token"}" }
      { "visitor_data": "${config.sops.placeholder."invidious/visitor_data"}" }
      { "invidious_companion_key": "${
        config.sops.placeholder."invidious/companion_key"
      }" }
    '';
    owner = "invidious";
    group = "invidious";
  };
}
