{config, pkgs-unstable, inputs, ...}:{
  # Add recyclarr module from unstable
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/recyclarr.nix"
  ];

  sops.secrets.radarr_api_key = {};
  sops.secrets.sonarr_api_key = {};

  sops.templates."recyclarr-secrets.yml".content = ''
movies_api_key: ${config.sops.placeholder.radarr_api_key}
tv_api_key: ${config.sops.placeholder.sonarr_api_key}
  '';

  # put the template at /var/lib/recyclarr/config.json
  systemd.tmpfiles.rules = [
    "L /var/lib/recyclarr/secrets.yml - - - - ${config.sops.templates."recyclarr-secrets.yml".path}"
  ];

  services.recyclarr = {
    enable = true;
    package = pkgs-unstable.recyclarr;

    configuration = {
      radarr.movies = {
        base_url = "https://sonarr.internal.internetfeno.men";
        api_key = "!secret movies_api_key";
      };
      sonarr.tv = {
        base_url = "https://radarr.internal.internetfeno.men";
        api_key = "!secret tv_api_key";
      };
    };
  };
}
