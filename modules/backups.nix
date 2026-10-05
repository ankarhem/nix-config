{ ... }:
let
  fileshare = {
    host = "fileshare.se";
    port = 9023;
    user = "internetfenomen-openssh-server";
    base = "/mnt/fileshare/restic";
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
      fileshareSsh = lib.concatStringsSep " " [
        "-o Port=${toString fileshare.port}"
        "-o IdentityFile=${config.sops.secrets."restic/fileshare_ssh_key".path}"
        "-o UserKnownHostsFile=${config.sops.secrets."restic/fileshare_known_hosts".path}"
        "-o BatchMode=yes"
        "-o IdentitiesOnly=yes"
        "-o ConnectTimeout=30"
        "-o ServerAliveInterval=30"
        "${fileshare.user}@${fileshare.host}"
      ];
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
                precondition = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Shell command that must succeed before a job touches the repository, proving the storage is the real one, so a missing mount fails the job instead of initialising a repository in the wrong place.";
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
            precondition = "[ \"$(stat -f -c %T /mnt/DISKETTEN_drive)\" = nfs ]";
            passwordFile = config.sops.secrets."restic/disketten".path;
          };
          fileshare = {
            repository = "sftp:${fileshare.user}@${fileshare.host}:${fileshare.base}";
            passwordFile = config.sops.secrets."restic/fileshare".path;
            extraOptions = [ "sftp.command='ssh ${fileshareSsh} -s sftp'" ];
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
          let
            resticCmd = "${lib.getExe pkgs.restic}${lib.concatMapStrings (o: " -o ${o}") p.extraOptions}";
          in
          lib.nameValuePair "restic-backups-${job}" {
            preStart = lib.mkBefore ''
              ${lib.optionalString (p.precondition != null) ''
                ${p.precondition} || { echo "${job}: provider precondition failed; refusing to back up" >&2; exit 1; }
              ''}
              rc=0
              ${resticCmd} cat --no-lock config > /dev/null || rc=$?
              if [ "$rc" -eq 10 ]; then
                ${resticCmd} init
              elif [ "$rc" -ne 0 ]; then
                exit "$rc"
              fi
              ${resticCmd} unlock
            '';
            serviceConfig.TimeoutStartSec = "4h";
          }
        ) jobs;
      };
    };
}
