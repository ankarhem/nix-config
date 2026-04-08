let
  cacheServerName = "homelab";
  cacheName = "main";
  cacheUrl = "https://attic.internetfeno.men";
  cachePublicKey = "9AeGSCEdFACRMznpA8b1LZtZ6cLkpdeTQ0Hqa0RmQAA="; # pragma: allowlist secret

  sharedModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        attic-client
      ];
      nix.settings = {
        substituters = [
          "${cacheUrl}/${cacheName}"
        ];

        trusted-public-keys = [
          "${cacheName}:${cachePublicKey}"
        ];
      };

      sops.secrets."attic/client_token" = { };
    };

in
{
  flake.modules.nixos.attic-client =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ sharedModule ];

      systemd.services.attic-watch-store = {
        description = "Watch the Nix store and push new paths to Attic";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = "root";
          Restart = "always";
          RestartSec = "5s";
          ExecStart =
            let
              atticBin = "${pkgs.attic-client}/bin/attic";
            in
            ''
              ${atticBin} login --set-default ${cacheServerName} ${cacheUrl} $(cat ${
                config.sops.secrets."attic/client_token".path
              }) || true
              ${atticBin} cache create ${cacheName} || true
              ${atticBin} cache info ${cacheName}
              ${atticBin} watch-store ${cacheName}
            '';
        };
      };
    };
  flake.modules.darwin.attic-client =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ sharedModule ];

      launchd.daemons.attic-watch-store = {
        script =
          let
            atticBin = "${pkgs.attic-client}/bin/attic";
          in
          ''
            ${atticBin} login --set-default ${cacheServerName} ${cacheUrl} $(cat ${
              config.sops.secrets."attic/client_token".path
            }) || true
            ${atticBin} cache create ${cacheName} || true
            ${atticBin} cache info ${cacheName}
            ${atticBin} watch-store ${cacheName}
          '';
        serviceConfig = {
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/var/log/attic-watch-store.log";
          StandardErrorPath = "/var/log/attic-watch-store.log";
        };
      };
    };
}
