{ inputs, ... }:
let
  port = 8087;
in
{
  flake.modules.nixos.redlib =
    { config, pkgs, ... }:
    {
      services.redlib = {
        enable = true;
        address = "127.0.0.1";
        package = pkgs.local.redlib;
        inherit port;

        settings = {
          SFW_ONLY = "on";
          ROBOTS_DISABLE_INDEXING = "on";
          # ENABLE_RSS = "on";
          BANNER = "Private instance";
        };
      };

      services.nginx.virtualHosts."redlib.internetfeno.men" = {
        forceSSL = true;
        useACMEHost = "internetfeno.men";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          extraConfig = ''
            proxy_http_version 1.1;
          '';
        };
      };
    };
}
