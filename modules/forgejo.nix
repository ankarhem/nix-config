{ inputs, ... }:
let
  port = 3020;
  sshPort = 2222;
  domain = "git.ankarhem.dev";
in
{
  flake.modules.nixos.forgejo =
    { config, ... }:
    {
      services.forgejo = {
        enable = true;
        lfs.enable = true;

        settings = {
          DEFAULT.APP_NAME = "Ankarhem Git";

          server = {
            HTTP_PORT = port;
            HTTP_ADDR = "127.0.0.1";
            DOMAIN = domain;
            ROOT_URL = "https://${domain}";
            START_SSH_SERVER = true;
            SSH_PORT = sshPort;
            SSH_LISTEN_PORT = sshPort;
          };

          session = {
            COOKIE_SECURE = true;
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ sshPort ];

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        extraConfig = ''
          client_max_body_size 100M;
        '';
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
}
