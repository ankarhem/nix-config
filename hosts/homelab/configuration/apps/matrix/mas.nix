{ config, pkgs, ... }:
let
  port = 8009;
  configFile = pkgs.writeTextFile {
    name = "mas-config.yaml";
    text = builtins.toJSON {
      http = {
        listeners = [{
          name = "web";
          resources = [
            { name = "discovery"; }
            { name = "human"; }
            { name = "oauth"; }
            { name = "compat"; }
            { name = "graphql"; }
          ];
          binds = [{ address = "[::]:${toString port}"; }];
          proxy_protocol = false;
        }];
        trusted_proxies = [
          "192.168.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/10"
          "127.0.0.1/8"
          "fd00::/8"
          "::1/128"
        ];
        public_base =
          "https://auth.${config.services.matrix-synapse.settings.server_name}/";
        issuer =
          "https://auth.${config.services.matrix-synapse.settings.server_name}/";
      };
      database = {
        host = "/run/postgresql";
        username = "matrix-authentication-service";
        database = "matrix-authentication-service";
        max_connections = 10;
        min_connections = 0;
        connect_timeout = 30;
        idle_timeout = 600;
        max_lifetime = 1800;
      };
      passwords = {
        enabled = true;
        schemes = [
          {
            version = 1;
            algorithm = "bcrypt";
          }
          {
            version = 2;
            algorithm = "argon2id";
          }
        ];
        minimum_complexity = 3;
      };
      matrix = {
        homeserver = config.meenzen.matrix.synapse.domain;
        endpoint =
          "http://[::1]:${toString config.meenzen.matrix.synapse.port}";
      };
    };
  };
in {
  services.nginx.virtualHosts."auth.${config.services.matrix-synapse.settings.server_name}" =
    {
      useACMEHost = "internetfeno.men";
      forceSSL = true;
      locations."/".proxyPass = "http://[::1]:${toString port}";
      locations."/assets" = {
        root =
          "${pkgs.matrix-authentication-service}/share/matrix-authentication-service";
        extraConfig = ''
          add_header Cache-Control "public, immutable, max-age=31536000";
        '';
      };
    };

  services.nginx.virtualHosts."${config.services.matrix-synapse.settings.public_baseurl}" =
    {
      locations."~ ^/_matrix/client/(.*)/(login|logout|refresh)".proxyPass =
        "http://[::1]:${toString port}";
    };

  sops.templates.mas_config.content = "";

  services.matrix-synapse.extras = [ "oidc" ];

  environment.systemPackages = [
    pkgs.matrix-authentication-service
    pkgs.syn2mas
    (pkgs.writeScriptBin "mas-cli-wrapper" ''
      sudo -u matrix-authentication-service ${pkgs.matrix-authentication-service}/bin/mas-cli --config=${configFile} --config=${config.sops.secrets.mas_config.path} $@
    '')
  ];

  users.users.matrix-authentication-service = {
    isSystemUser = true;
    group = "matrix-authentication-service";
    description = "Matrix Authentication Service user";
  };
  users.groups.matrix-authentication-service = { };

  systemd.services."matrix-authentication-service" = {
    enable = true;
    description = "MAS";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" "postgresql.service" ];
    requires = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart =
        "${pkgs.matrix-authentication-service}/bin/mas-cli --config=${configFile} --config=${config.sops.secrets.mas_config.path} server";
      User = "matrix-authentication-service";
      Group = "matrix-authentication-service";
      Restart = "on-failure";
    };
  };

  services.postgresql = {
    ensureUsers = [{
      name = "matrix-authentication-service";
      ensureDBOwnership = true;
    }];
  };
  ensureDatabases = [ "matrix-authentication-service" ];
}
