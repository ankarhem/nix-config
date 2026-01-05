# Docker aspect - NixOS oci-containers auto-updater
{ config, lib, ... }:
let
  cfg = config.virtualisation.oci-containers.autoUpdater;
in
{
  options.virtualisation.oci-containers.autoUpdater = {
    enable = lib.mkEnableOption "Enable Watchtower auto-updates for OCI containers";

    interval = lib.mkOption {
      type = lib.types.int;
      default = 60;
      description = lib.mdDoc ''
        Interval in seconds for Watchtower to check for updates.
      '';
    };

    containers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options.enable = lib.mkEnableOption "Enable auto-update for this container";
          }
        )
      );
      default = { };
      description = "Per-container auto-update flags keyed by container name.";
    };
  };

  config = lib.mkMerge [
    # Provide the watchtower container when enabled.
    (lib.mkIf cfg.enable {
      virtualisation.oci-containers.containers.watchtower = lib.mkMerge [
        {
          image = "containrrr/watchtower:latest";
          cmd = [
            # Only fetch new images, do not attempt to restart containers:
            "--no-restart"
            # By default, update only containers with the label:
            "--label-enable"
            # Cleanup old images after updating:
            "--cleanup"
            # Polling interval:
            "--interval=${toString cfg.interval}"
          ];
          # Do not update watchtower itself unless explicitly opted-in:
          labels = {
            "com.centurylinklabs.watchtower.enable" = "false";
          };
          autoStart = true;
        }
        (lib.mkIf (config.virtualisation.oci-containers.backend == "docker") {
          volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
        })
        (lib.mkIf (config.virtualisation.oci-containers.backend == "podman") {
          volumes = [ "/run/podman/podman.sock:/var/run/docker.sock" ];
        })
      ];
    })

    {
      virtualisation.oci-containers.containers = lib.mkAfter (
        lib.mapAttrs (
          name: containerCfg:
          lib.mkIf containerCfg.enable {
            labels = {
              "com.centurylinklabs.watchtower.enable" = "true";
            };
          }
        ) cfg.containers
      );
    }
  ];
}
