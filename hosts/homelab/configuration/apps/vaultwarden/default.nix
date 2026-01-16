{
  config,
  lib,
  pkgs,
  ...
}:
let
  domain = "vault.ankarhem.dev";
  port = 8222;

  backupGpgHomePath = "/var/lib/backup/.gnupg";
  backupScript = pkgs.writeShellApplication {
    name = "vaultwarden-backup";
    runtimeInputs = [
      pkgs.sqlite
      pkgs.busybox
      pkgs.gnupg
    ];
    text = (builtins.readFile ./backup.sh);
  };

  syncScript = pkgs.writeShellApplication {
    name = "vaultwarden-sync";
    runtimeInputs = [
      pkgs.rsync
      pkgs.openssh
    ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      DISKETTEN_PATH=/mnt/DISKETTEN_drive/vaultwarden
      FILESHARE_PATH=/mnt/fileshare/vaultwarden
      # Create folder if not exists
      if [ ! -d "$DISKETTEN_PATH" ]; then
        echo "Folder $DISKETTEN_PATH does not exist, creating it."
        mkdir -p $DISKETTEN_PATH
      fi

      # BACKUP_FOLDER is a default environment variable set in the nixos module
      # which is the folder set at services.vaultwarden.backupDir
      rsync -avh --delete --no-owner --no-group "$BACKUP_FOLDER/" "$DISKETTEN_PATH/" || {
        echo "Error: failed to sync Vaultwarden backup to Synology NAS." >&2
        exit 1
      }
      echo "Successfully synced Vaultwarden backups to Synology NAS."
      rsync -avh --delete --no-owner --no-group -e 'ssh -p 9023 -i ${
        config.sops.secrets."vaultwarden/ssh_key".path
      } -o UserKnownHostsFile=${
        config.sops.secrets."vaultwarden/fileshare_known_hosts_file".path
      } ' "$BACKUP_FOLDER/" internetfenomen-openssh-server@fileshare.se:"$FILESHARE_PATH/" || {
        echo "Error: failed to sync Vaultwarden backup to Fileshare." >&2
        exit 1
      }
      echo "Successfully synced Vaultwarden backups to Fileshare."
    '';
  };
in
{
  environment.systemPackages = [ backupScript ];

  sops.secrets = {
    "smtp/username" = { };
    "smtp/password" = { };
    "vaultwarden/admin_token" = { };
    "vaultwarden/installation_id" = { };
    "vaultwarden/installation_key" = { };
    "vaultwarden/fileshare_known_hosts_file" = {
      owner = config.users.users.vaultwarden.name;
      group = config.users.users.vaultwarden.group;
    };
    "vaultwarden/symmetric_key" = {
      owner = config.users.users.vaultwarden.name;
      group = config.users.users.vaultwarden.group;
    };
    "vaultwarden/ssh_key" = {
      owner = config.users.users.vaultwarden.name;
      group = config.users.users.vaultwarden.group;
    };
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
      PUSH_INSTALLATION_ID=${config.sops.placeholder."vaultwarden/installation_id"}
      PUSH_INSTALLATION_KEY=${config.sops.placeholder."vaultwarden/installation_key"}
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
  systemd.services.backup-vaultwarden = {
    environment = {
      GNUPGHOME = backupGpgHomePath;
      PASSWORD_FILE = config.sops.secrets."vaultwarden/symmetric_key".path;
      KNOWN_HOSTS_FILE = config.sops.secrets."vaultwarden/fileshare_known_hosts_file".path;
    };
    serviceConfig = {
      ExecStart = lib.mkForce "${pkgs.bash}/bin/bash ${backupScript}/bin/${backupScript.name}";
      ExecStartPost = "${pkgs.bash}/bin/bash ${syncScript}/bin/${syncScript.name}";
    };
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
    "fail2ban/filter.d/vaultwarden.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*?Username or password is incorrect\. Try again\. IP: <ADDR>\. Username:.*$
        ignoreregex =
      ''
    );
    "fail2ban/filter.d/vaultwarden-admin.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*Invalid admin token\. IP: <ADDR>.*$
        ignoreregex =
      ''
    );
    "fail2ban/filter.d/vaultwarden-totp.local".text = pkgs.lib.mkDefault (
      pkgs.lib.mkAfter ''
        [INCLUDES]
        before = common.conf

        [Definition]
        failregex = ^.*\[ERROR\] Invalid TOTP code! Server time: (.*) UTC IP: <ADDR>$
        ignoreregex =
      ''
    );
  };

  systemd.tmpfiles.rules = [
    "d /var/log/nginx/vaultwarden 0750 nginx nginx - -"
    "d ${backupGpgHomePath} 0700 vaultwarden vaultwarden - -"
  ];
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
