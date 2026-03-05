{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.services.opencode-server;
in
{
  options.services.opencode-server = {
    enable = mkEnableOption "OpenCode server (remote coding agent backend)";

    package = mkOption {
      type = types.package;
      default = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      description = "OpenCode server package";
    };

    port = mkOption {
      type = types.port;
      default = 4096;
      description = "Port for OpenCode server";
    };

    hostname = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Hostname for OpenCode server to bind to";
    };

    workingDir = mkOption {
      type = types.str;
      description = "Working directory for OpenCode server";
    };

    user = mkOption {
      type = types.str;
      description = "User to run OpenCode server as";
    };

    environmentFiles = mkOption {
      type = types.listOf types.path;
      description = "List of environment files to load for OpenCode server";
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.enable && pkgs.stdenv.isDarwin);
        message = "OpenCode server is only supported on NixOS Linux. On macOS, install via Homebrew.";
      }
    ];

    # Create working directory
    systemd.tmpfiles.rules = [
      "d ${cfg.workingDir} 0755 ${cfg.user} users -"
    ];

    # OpenCode server systemd service
    systemd.services.opencode-server = {
      description = "OpenCode server - remote coding agent backend";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "users";
        WorkingDirectory = cfg.workingDir;
        ExecStart = "${cfg.package}/bin/opencode web --port ${toString cfg.port} --hostname ${cfg.hostname}";
        Restart = "on-failure";
        RestartSec = 5;

        # Security hardening
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        ReadWritePaths = [
          cfg.workingDir
          "/home/${cfg.user}/.local/share/opencode"
          "/home/${cfg.user}/.config/opencode"
        ];
        EnvironmentFile = cfg.environmentFiles;
      };
    };
  };
}
