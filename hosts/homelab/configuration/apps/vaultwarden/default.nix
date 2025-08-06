{ config, lib, pkgs, ... }:
let
  domain = "vault.ankarhem.dev";
  port = 8222;

  backupScript = pkgs.writeShellApplication {
    name = "vaultwarden-backup";
    runtimeInputs = [ pkgs.sqlite pkgs.busybox ];
    text = (builtins.readFile ./backup.sh);
  };

  syncScript = pkgs.writeShellApplication {
    name = "vaultwarden-sync";
    runtimeInputs = [ pkgs.rsync ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SYNOLOGY_PATH=/mnt/DISKETTEN_drive/vaultwarden
      # Create folder if not exists
      if [ ! -d "$SYNOLOGY_PATH" ]; then
        echo "Folder $SYNOLOGY_PATH does not exist, creating it."
        mkdir -p $SYNOLOGY_PATH
      fi

      # BACKUP_FOLDER is a default environment variable set in the nixos module
      # which is the folder set at services.vaultwarden.backupDir
      rsync -avh --delete --no-owner --no-group "$BACKUP_FOLDER/" "$SYNOLOGY_PATH/" || {
        echo "Error: failed to sync Vaultwarden backup to Synology NAS." >&2
        exit 1
      }
    '';
  };
in {
  environment.systemPackages = [ backupScript ];

  sops.secrets = {
    "smtp/username" = { };
    "smtp/password" = { };
    "vaultwarden/admin_token" = { };
    "vaultwarden/installation_id" = { };
    "vaultwarden/installation_key" = { };
  };
  sops.templates."vaultwarden.env" = {
    content = ''
      ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin_token"}
      SMTP_HOST=smtp.mail.me.com
      SMTP_FROM=admin@ankarhem.dev
      SMTP_PORT=587
      SMTP_SECURITY=starttls
      SMTP_USERNAME=${config.sops.placeholder."smtp/username"}
      SMTP_PASSWORD=${config.sops.placeholder."smtp/password"}
      PUSH_ENABLED=true
      PUSH_RELAY_URI=https://api.bitwarden.eu
      PUSH_IDENTITY_URI=https://identity.bitwarden.eu
      PUSH_INSTALLATION_ID=${
        config.sops.placeholder."vaultwarden/installation_id"
      }
      PUSH_INSTALLATION_KEY=${
        config.sops.placeholder."vaultwarden/installation_key"
      }
    '';
  };

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    backupDir = "/var/backup/vaultwarden";
    environmentFile = config.sops.templates."vaultwarden.env".path;
    config = {
      domain = "https://${domain}";
      rocketAddress = "127.0.0.1";
      rocketPort = port;
      signupsAllowed = false;
      invitationsAllowed = true;
    };
  };
  ## Override the backup script, and make it more frequent
  systemd.services.backup-vaultwarden.serviceConfig = {
    ExecStart = lib.mkForce
      "${pkgs.bash}/bin/bash ${backupScript}/bin/${backupScript.name}";
    ExecStartPost =
      "${pkgs.bash}/bin/bash ${syncScript}/bin/${syncScript.name}";
  };
  systemd.timers.backup-vaultwarden.timerConfig.OnCalendar = "hourly";

  ## FIREWALL
  services.fail2ban = {
    jails = {
      vaultwarden.settings = {
        enabled = true;
        port = "80,443,8081";
        filter = "vaultwarden";
        banaction = ''
          cf
          iptables-multiport[name=vaultwarden, port="http,https"]'';
        logpath = "/var/logs/nginx/vaultwarden/*.log";
        maxretry = 5;
        bantime = 14400;
        findtime = 14400;
      };
      vaultwarden-admin.settings = {
        enabled = true;
        port = "80,443";
        filter = "vaultwarden-admin";
        banaction = ''
          cf
          iptables-multiport[name=vaultwarden-admin, port="http,https"]'';
        logpath = "/var/logs/nginx/vaultwarden/*.log";
        maxretry = 3;
        bantime = 14400;
        findtime = 14400;
      };
      vaultwarden-totp.settings = {
        enabled = true;
        port = "80,443";
        filter = "vaultwarden-totp";
        banaction = ''
          cf
          iptables-multiport[name=vaultwarden-totp, port="http,https"]'';
        logpath = "/var/logs/nginx/vaultwarden/*.log";
        maxretry = 3;
        bantime = 14400;
        findtime = 14400;
      };
    };
  };
  environment.etc = {
    "fail2ban/filter.d/vaultwarden.local".text = pkgs.lib.mkDefault
      (pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*?Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
      '');
    "fail2ban/filter.d/vaultwarden-admin.local".text = pkgs.lib.mkDefault
      (pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
        ignoreregex =
      '');
    "fail2ban/filter.d/vaultwarden-totp.local".text = pkgs.lib.mkDefault
      (pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*\[ERROR\] Invalid TOTP code! Server time: (.*) UTC IP: <ADDR>$
        ignoreregex =
      '');
  };

  systemd.tmpfiles.rules =
    [ "d /var/log/nginx/vaultwarden 0750 nginx nginx - -" ];
  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    extraConfig = ''
      access_log /var/log/nginx/vaultwarden/access.log;
      error_log /var/log/nginx/vaultwarden/error.log;
    '';
    locations."/" = {
      proxyWebsockets = true;
      proxyPass = "http://127.0.0.1:${toString port}";
    };
  };
}
