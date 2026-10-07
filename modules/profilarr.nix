{ ... }:
let
  domain = "profilarr.internal.internetfeno.men";
  port = 6868;
  dataDir = "/var/lib/profilarr";
in
{
  flake.modules.nixos.profilarr =
    { lib, pkgs, ... }:
    let
      package = pkgs.local.profilarr.override { inherit (pkgs._unstable) deno; };
    in
    {
      users.users.profilarr = {
        isSystemUser = true;
        group = "profilarr";
        home = dataDir;
      };
      users.groups.profilarr = { };

      systemd.services.profilarr = {
        description = "Profilarr";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        environment = {
          APP_BASE_PATH = dataDir;
          HOST = "127.0.0.1";
          PORT = toString port;
          ORIGIN = "https://${domain}";
        };

        serviceConfig = {
          ExecStart = lib.getExe package;
          User = "profilarr";
          Group = "profilarr";
          StateDirectory = "profilarr";
          StateDirectoryMode = "0750";
          WorkingDirectory = dataDir;
          Restart = "on-failure";
          UMask = "0027";

          CapabilityBoundingSet = "";
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };

      services.backups.sources.profilarr.paths = [ "${dataDir}/backups" ];

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "internal.internetfeno.men";
        extraConfig = ''
          client_max_body_size 1G;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
}
