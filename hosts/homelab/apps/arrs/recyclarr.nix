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
      };
      sonarr.tv = {
        base_url = "https://sonarr.internal.internetfeno.men";
        api_key._secret = "/run/credentials/recyclarr.service/sonarr_api_key";
      };
    };
  };
}
