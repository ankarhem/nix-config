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
      sops.secrets = {
        "smtp/username" = { };
        "smtp/password" = { };
      };
      services.forgejo = {
        enable = true;
        lfs.enable = true;

        secrets.mailer.PASSWD = config.sops.secrets."smtp/password".path;
        secrets.mailer.USER = config.sops.secrets."smtp/username".path;
        settings = {
          service.DISABLE_REGISTRATION = true;
          DEFAULT.APP_NAME = "forgejo";
          log.LEVEL = "Debug";
          federation.ENABLED = true;
          ui = {
            DEFAULT_THEME = "forgejo-dark";
            SHOW_USER_EMAIL = true;
          };
          actions = {
            ENABLED = false;
            DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
          };

          mailer = {
            ENABLED = true;
            FROM = "Forgejo <admin@ankarhem.dev>";
            PROTOCOL = "smtp+starttls";
            SMTP_ADDR = "smtp.mail.me.com";
            SMTP_PORT = 587;
          };
          security = {
            LOGIN_REMEMBER_DAYS = 365;
          };
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

      services.fail2ban.jails.forgejo = {
        settings = {
          filter = "forgejo";
          action = "iptables-allports";
          mode = "aggressive";
          maxretry = 3;
          findtime = 3600;
          bantime = 900;
        };
      };
      environment.etc = {
        "fail2ban/filter.d/forgejo.conf".text = ''
          [Definition]
          failregex = ^.*(Failed authentication attempt|invalid credentials|Attempted access of unknown user).* from <HOST>$
          journalmatch = _SYSTEMD_UNIT=forgejo.service
        '';
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
