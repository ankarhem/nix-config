{config, pkgs-unstable, inputs, ...}:{
  # Add recyclarr module from unstable
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/recyclarr.nix"
  ];

  sops.secrets.radarr_api_key = {};
  sops.secrets.sonarr_api_key = {};

  systemd.services.recyclarr.serviceConfig.LoadCredential = [
    "radarr_api_key:${config.sops.secrets.radarr_api_key.path}"
    "sonarr_api_key:${config.sops.secrets.sonarr_api_key.path}"
  ];

  services.recyclarr = {
    enable = true;
    package = pkgs-unstable.recyclarr;

    configuration = {
      radarr.movies = {
        base_url = "https://radarr.internal.internetfeno.men";
        api_key._secret = "/run/credentials/recyclarr.service/radarr_api_key";

        delete_old_custom_formats = true;
        replace_existing_custom_formats = true;

        media_naming = {
          folder = "plex-tmdb";
          movie = {
            rename = true;
            standard = "plex-tmdb";
          };
        };

        include = [
          # Comment out any of the following includes to disable them
          { template = "radarr-quality-definition-movie"; }
          { template = "radarr-quality-profile-hd-bluray-web"; }
          { template = "radarr-custom-formats-hd-bluray-web"; }
        ];
      };
      sonarr.tv = {
        base_url = "https://sonarr.internal.internetfeno.men";
        api_key._secret = "/run/credentials/recyclarr.service/sonarr_api_key";

        delete_old_custom_formats = true;
        replace_existing_custom_formats = true;

        media_naming = {
          series = "default";
          season = "default";
          episodes = {
            rename = true;
            standard = "default";
            daily = "default";
            anime = "default";
          };
        };

        include = [
          # Comment out any of the following includes to disable them
          { template = "sonarr-quality-definition-series"; }
          { template = "sonarr-v4-quality-profile-web-1080p"; }
          { template = "sonarr-v4-custom-formats-web-1080p"; }
        ];
      };
    };
  };
}
