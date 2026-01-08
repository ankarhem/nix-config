{ config, ... }:
let
  port = 5656;
in
{
  services.nginx.virtualHosts."unpackerr.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${builtins.toString port}";
    };
  };

  sops.secrets.radarr_api_key = { };
  sops.secrets.sonarr_api_key = { };

  sops.templates."unpackerr.env".content = ''
    UN_RADARR_0_API_KEY=${config.sops.placeholder.radarr_api_key}
    UN_SONARR_0_API_KEY=${config.sops.placeholder.sonarr_api_key}
  '';

  virtualisation.oci-containers.containers."unpackerr" = {
    image = "golift/unpackerr";
    environmentFiles = [ config.sops.templates."unpackerr.env".path ];
    environment = {
      "TZ" = "Europe/Stockholm";
      "UN_DEBUG" = "false";
      "UN_DIR_MODE" = "0755";
      "UN_FILE_MODE" = "0644";
      "UN_INTERVAL" = "2m";
      "UN_LOG_FILE" = "";
      "UN_LOG_FILES" = "10";
      "UN_LOG_FILE_MB" = "10";
      "UN_MAX_RETRIES" = "3";
      "UN_PARALLEL" = "5";
      "UN_RADARR_0_DELETE_DELAY" = "60m";
      "UN_RADARR_0_DELETE_ORIG" = "false";
      "UN_RADARR_0_PATHS_0" = "/mnt/DISKETTEN_media/downloads";
      "UN_RADARR_0_PROTOCOLS" = "torrent";
      "UN_RADARR_0_TIMEOUT" = "10s";
      "UN_RADARR_0_URL" = "https://radarr.internal.internetfeno.men";
      "UN_RETRY_DELAY" = "5m";
      "UN_SONARR_0_DELETE_DELAY" = "60m";
      "UN_SONARR_0_DELETE_ORIG" = "false";
      "UN_SONARR_0_PATHS_0" = "/mnt/DISKETTEN_media/downloads";
      "UN_SONARR_0_PROTOCOLS" = "torrent";
      "UN_SONARR_0_TIMEOUT" = "10s";
      "UN_SONARR_0_URL" = "https://sonarr.internal.internetfeno.men";
      "UN_START_DELAY" = "30s";
      "UN_WEBSERVER_LISTEN_ADDR" = "0.0.0.0:${toString port}";
      "UN_WEBSERVER_LOG_FILE" = "";
      "UN_WEBSERVER_LOG_FILES" = "10";
      "UN_WEBSERVER_LOG_FILE_MB" = "10";
      "UN_WEBSERVER_METRICS" = "false";
      "UN_WEBSERVER_SSL_CERT_FILE" = "";
      "UN_WEBSERVER_SSL_KEY_FILE" = "";
      "UN_WEBSERVER_UPSTREAMS" = "";
      "UN_WEBSERVER_URLBASE" = "/";
    };
    volumes = [ "/mnt/DISKETTEN_media/downloads:/mnt/DISKETTEN_media/downloads:rw" ];
  };
}
