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

        media_naming = {
          folder = "plex-tmdb";
          movie = {
            rename = true;
            standard = "plex-tmdb";
          };
        };

        quality_definition.type = "movie";
        quality_profiles = [
          {
            trash_id = "d1d67249d3890e49bc12e275d989a7e9"; # HD Bluray + WEB
            name = "HD Bluray + WEB";
            reset_unmatched_scores.enabled = true;
          }
        ];
      };
      sonarr.tv = {
        base_url = "https://sonarr.internal.internetfeno.men";
        api_key._secret = config.sops.secrets."arr_tokens/sonarr".path;

        delete_old_custom_formats = true;

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

        quality_definition.type = "series";
        quality_profiles = [
          {
            trash_id = "72dae194fc92bf828f32cde7744e51a1"; # WEB-1080p
            name = "WEB-1080p";
            reset_unmatched_scores.enabled = true;
          }
        ];
      };
    };
  };
}
