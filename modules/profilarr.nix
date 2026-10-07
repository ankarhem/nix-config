{ ... }:
let
  domain = "profilarr.internal.internetfeno.men";
  port = "6868";
  dataDir = "/var/lib/profilarr";
  uid = "1000";
in
{
  flake.modules.nixos.profilarr =
    { ... }:
    {
      systemd.tmpfiles.rules = [ "d ${dataDir} 0750 ${uid} ${uid} -" ];

      virtualisation.oci-containers.containers.profilarr = {
        image = "ghcr.io/dictionarry-hub/profilarr:latest";
        ports = [ "127.0.0.1:${port}:${port}" ];
        volumes = [ "${dataDir}:/config" ];
        environment = {
          PUID = uid;
          PGID = uid;
          UMASK = "027";
          TZ = "Europe/Stockholm";
          ORIGIN = "https://${domain}";
        };
      };

      virtualisation.oci-containers.autoUpdater.containers.profilarr.enable = true;

      # services.backups.sources.profilarr.paths = [ "${dataDir}/backups" ];

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "internal.internetfeno.men";
        extraConfig = ''
          client_max_body_size 1G;
        '';
        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}";
          proxyWebsockets = true;
        };
      };
    };
}
