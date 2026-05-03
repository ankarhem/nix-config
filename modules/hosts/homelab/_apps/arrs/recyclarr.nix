{
  config,
  inputs,
  ...
}:
{
  sops.secrets."arr_tokens/radarr" = { };
  sops.secrets."arr_tokens/sonarr" = { };

  services.recyclarr = {
    enable = true;

    configuration = {
      radarr.movies = {
        base_url = "https://radarr.internal.internetfeno.men";
        api_key._secret = config.sops.secrets."arr_tokens/radarr".path;

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
        api_key._secret = config.sops.secrets."arr_tokens/sonarr".path;

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
