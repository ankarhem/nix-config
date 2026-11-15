{ ... }:
let
  domain = "threadfin.internal.internetfeno.men";
  port = "34400";
  dataDir = "/var/lib/threadfin";
in
{
  flake.modules.nixos.threadfin =
    { ... }:
    {
      systemd.tmpfiles.rules = [ "d ${dataDir} 0750 root root -" ];

      virtualisation.oci-containers.containers.qbittorrent = {
        ports = [ "127.0.0.1:${port}:${port}" ];
        environment.VPN_INPUT_PORTS = port;
      };

      virtualisation.oci-containers.containers.threadfin = {
        image = "fyb3roptik/threadfin:latest";
        dependsOn = [ "qbittorrent" ];
        volumes = [ "${dataDir}:/home/threadfin/conf" ];
        environment.TZ = "Europe/Stockholm";
        extraOptions = [ "--network=container:qbittorrent" ];
      };

      virtualisation.oci-containers.autoUpdater.containers.threadfin.enable = true;

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "internal.internetfeno.men";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${port}";
          proxyWebsockets = true;
        };
      };
    };
}
