{config, ...}:let
  port = "8080";
in {
  sops.secrets.qbittorrent_env = {
    sopsFile = ../../../../secrets/homelab/qbittorrent.env;
    format = "dotenv";
  };

  services.nginx.virtualHosts."qbittorrent.internal.internetfeno.men" =  {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${port}";
    };
  };

  virtualisation.oci-containers.containers."qbittorrent" = {
    image = "binhex/arch-qbittorrentvpn";
    environment = {
      "DEBUG" = "false";
      "ENABLE_PRIVOXY" = "yes";
      "LAN_NETWORK" = "192.168.1.0/24";
      "NAME_SERVERS" = "84.200.69.80,37.235.1.174,1.1.1.1,37.235.1.177,84.200.70.40,1.0.0.1";
      # "PGID" = "1000";
      # "PUID" = "1000";
      "STRICT_PORT_FORWARD" = "yes";
      # "UMASK" = "000";
      "VPN_CLIENT" = "wireguard";
      "VPN_ENABLED" = "yes";
      "VPN_PROV" = "pia";
      "WEBUI_PORT" = port;
    };
    ports = ["127.0.0.1:${port}:${port}"];
    environmentFiles= [
      config.sops.secrets.qbittorrent_env.path
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/mnt/DISKETTEN_media/downloads/:/data:rw"
      "/var/lib/qbittorrent/config:/config:rw"
    ];
    extraOptions = [
      "--privileged"
      "--sysctl=net.ipv4.conf.all.src_valid_mark=1"
    ];
  };

}
