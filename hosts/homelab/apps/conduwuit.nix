{
  lib,
  ...
}: let
  conduwuit.port = 6167;
  element-web.port = 8009;
  maubot.port = 29316;
in {
  networking.firewall.allowedTCPPorts = [
    conduwuit.port
    element-web.port
    maubot.port
  ];

  # Nginx
  services.nginx.virtualHosts."matrix.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";

    extraConfig = ''
      listen 8448 ssl http2 default_server;

      client_max_body_size 50M;
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString conduwuit.port}";
    };
  };
  services.nginx.virtualHosts."element.internetfeno.men" = {
    serverAliases = [
      "chat.internetfeno.men"
    ];
    forceSSL = true;
    useACMEHost = "internetfeno.men";
    extraConfig = ''
      add_header X-Frame-Options SAMEORIGIN;
      add_header X-Content-Type-Options nosniff;
      add_header X-XSS-Protection "1; mode=block";
      add_header Content-Security-Policy "frame-ancestors 'self'";
    '';
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString element-web.port}";
    };
  };

  # Containers
  virtualisation.oci-containers.containers."conduwuit" = {
    image = "girlbossceo/conduwuit:latest";
    environment = {
      "CONDUWUIT_ADDRESS" = "0.0.0.0";
      "CONDUWUIT_CONFIG" = "/etc/conduwuit.toml";
      "CONDUWUIT_PORT" = toString conduwuit.port;
    };
    volumes = [
      "/var/lib/matrix/conduwuit/.registry_tokens:/etc/conduwuit/.registry_tokens:rw"
      "/var/lib/matrix/conduwuit/conduwuit.toml:/etc/conduwuit.toml:rw"
      "/var/lib/matrix/conduwuit/db:/var/lib/conduwuit:rw"
    ];
    ports = [
      "127.0.0.1:${toString conduwuit.port}:${toString conduwuit.port}/tcp"
    ];
  };
  virtualisation.oci-containers.containers."element-web" = {
    image = "vectorim/element-web:v1.11.94";
    environment = {
      ELEMENT_WEB_PORT = toString element-web.port;
    };
    ports = [
      "127.0.0.1:${toString element-web.port}:${toString element-web.port}/tcp"
    ];
  };
  virtualisation.oci-containers.containers."maubot" = {
    image = "dock.mau.dev/maubot/maubot:v0.5.1";
    volumes = [
      "/var/lib/matrix/maubot:/data:rw"
    ];
    ports = [
      "127.0.0.1:${toString maubot.port}:${toString maubot.port}/tcp"
    ];
  };
  virtualisation.oci-containers.containers."mautrix-instagram" = {
    image = "dock.mau.dev/mautrix/meta:v0.4.4";
    volumes = [
      "/var/lib/matrix/instagram-bridge:/data:rw"
    ];
  };
  virtualisation.oci-containers.containers."mautrix-telegram" = {
    image = "dock.mau.dev/mautrix/telegram:v0.15.2";
    volumes = [
      "/var/lib/matrix/telegram-bridge:/data:rw"
    ];
  };
}
