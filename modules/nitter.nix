{ inputs, ... }:
let
  port = 8088;
  domain = "nitter.internetfeno.men";
in
{
  flake.modules.nixos.nitter =
    { config, ... }:
    {
      services.nitter = {
        enable = true;
        server = {
          address = "127.0.0.1";
          inherit port;
          hostname = domain;
          https = true;
          title = "Nitter";
        };

        # Nitter needs real Twitter/X account sessions to authenticate
        # API requests. JSONL, one line per account, see
        # https://github.com/zedeus/nitter/wiki/Creating-session-tokens
        sessionsFile = config.sops.secrets."nitter/sessions".path;

        preferences = {
          replaceTwitter = domain;
          replaceReddit = "redlib.internetfeno.men";
        };
      };

      sops.secrets."nitter/sessions" = { };

      services.nginx.virtualHosts."${domain}" = {
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
