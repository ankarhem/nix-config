{ inputs, ... }:
let
  port = 14523;
in
{
  flake.modules.nixos.attic =
    { config, ... }:
    {
      sops.secrets."attic/server_token" = { };
      sops.templates."attic.env".content = ''
        ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64=${config.sops.placeholder."attic/server_token"}
      '';

      services.atticd = {
        enable = true;

        # Replace with absolute path to your environment file
        environmentFile = config.sops.templates."attic.env".path;

        settings = {
          storage = {
            type = "local";
            path = "/mnt/DISKETTEN_drive/attic";
          };

          listen = "[::]:${toString port}";
          jwt = { };

          allowed-hosts = [ "attic.internetfeno.men" ];

          garbage-collection = {
            interval = "12 hours";
            default-retention-period = "30 days";
          };

          chunking = {
            nar-size-threshold = 64 * 1024; # 64 KiB
            min-size = 16 * 1024; # 16 KiB
            avg-size = 64 * 1024; # 64 KiB
            max-size = 256 * 1024; # 256 KiB
          };
        };
      };

      services.nginx.virtualHosts."attic.internetfeno.men" = {
        forceSSL = true;
        useACMEHost = "internetfeno.men";
        locations."/" = {
          extraConfig = ''
            client_max_body_size 0;
            proxy_request_buffering off;
            client_body_buffer_size 1024k;
            proxy_read_timeout 600s;
            proxy_send_timeout 600s;
            send_timeout       600s;
          '';
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
}
