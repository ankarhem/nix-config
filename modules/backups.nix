{ ... }:
let
  fileshare = {
    host = "fileshare.se";
    port = 9023;
    user = "internetfenomen-openssh-server";
  };
in
{
  flake.modules.nixos.backups =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.backups;
      inherit (lib) mkOption types;
      jobs = lib.concatMapAttrs (
        source: s:
        lib.mapAttrs' (
          provider: p: lib.nameValuePair "${source}-${provider}" { inherit source s p; }
        ) cfg.providers
      ) cfg.sources;
    in
    {
      options.services.backups = {
        providers = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                repository = mkOption { type = types.str; };
                passwordFile = mkOption { type = types.str; };
                extraOptions = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };
              };
            }
          );
          default = { };
        };
        sources = mkOption {
          type = types.attrsOf (
            types.submodule {
              options = {
                paths = mkOption { type = types.listOf types.str; };
                exclude = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };
                prepareCommand = mkOption {
                  type = types.nullOr types.lines;
                  default = null;
                  description = "Runs as root under `set -euo pipefail` before each provider's backup, so jobs may overlap; write dumps atomically (temp file in an excluded dir, then mv).";
                };
                onCalendar = mkOption {
                  type = types.str;
                  default = "daily";
                };
                pruneOpts = mkOption {
                  type = types.listOf types.str;
                  default = [
                    "--keep-daily 7"
                    "--keep-weekly 4"
                    "--keep-monthly 12"
                  ];
                };
              };
            }
          );
          default = { };
        };
      };

      config = {
        sops.secrets = {
          "restic/disketten" = { };
          "restic/fileshare" = { };
          "restic/fileshare_ssh_key" = { };
          "restic/fileshare_known_hosts" = { };
        };

        services.backups.providers = {
          disketten = {
            repository = "/mnt/DISKETTEN_drive/restic";
            passwordFile = config.sops.secrets."restic/disketten".path;
          };
          fileshare = {
            repository = "sftp:${fileshare.user}@${fileshare.host}:/mnt/fileshare/restic";
            passwordFile = config.sops.secrets."restic/fileshare".path;
            extraOptions = [
              "sftp.command='ssh -p ${toString fileshare.port} -i ${
                config.sops.secrets."restic/fileshare_ssh_key".path
              } -o UserKnownHostsFile=${
                config.sops.secrets."restic/fileshare_known_hosts".path
              } -o BatchMode=yes -o IdentitiesOnly=yes -o ConnectTimeout=30 -o ServerAliveInterval=30 ${fileshare.user}@${fileshare.host} -s sftp'"
            ];
          };
        };

        services.restic.backups = lib.mapAttrs (
          _:
          {
            source,
            s,
            p,
          }:
          {
            inherit (s) paths exclude pruneOpts;
            inherit (p) passwordFile extraOptions;
            repository = "${p.repository}/${source}";
            backupPrepareCommand = lib.mapNullable (c: ''
              #!${pkgs.runtimeShell}
              set -euo pipefail
              ${c}
            '') s.prepareCommand;
            timerConfig = {
              OnCalendar = s.onCalendar;
              Persistent = true;
              RandomizedDelaySec = "5m";
            };
            checkOpts = [ "--with-cache" ];
          }
        ) jobs;

        systemd.services = lib.mapAttrs' (
          job:
          { p, ... }:
          lib.nameValuePair "restic-backups-${job}" {
            preStart = lib.mkBefore "${lib.getExe pkgs.restic}${
              lib.concatMapStrings (o: " -o ${o}") p.extraOptions
            } unlock";
            serviceConfig.TimeoutStartSec = "4h";
          }
        ) jobs;
      };
    };
}
