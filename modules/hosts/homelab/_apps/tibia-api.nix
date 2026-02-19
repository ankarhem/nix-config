{ ... }:
let
  port = "7032";
in
{
  services.nginx.virtualHosts."tibia.ankarhem.dev" = {
    forceSSL = true;
    enableACME = true;
    serverAliases = [ "api.tibiacenter.com" ];
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };
  virtualisation.oci-containers.containers = {
    tibia-api = {
      image = "ghcr.io/ankarhem/tibia-api-rust:main";
      ports = [ "127.0.0.1:${port}:${port}" ];
      environment = {
        PORT = port;
        RUST_LOG = "info,html5ever=error";
      };
      volumes = [
        "/var/lib/tibia-api/logs:/app/logs"
        "/var/lib/tibia-api/cache:/app/http-cacache"
      ];
    };
  };
}
