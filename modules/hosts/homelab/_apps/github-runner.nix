{ config, pkgs, ... }:
{
  sops.secrets."github/runner_token" = { };

  services.github-runners.homelab = {
    enable = true;
    url = "https://github.com/ankarhem";
    tokenFile = config.sops.secrets."github/runner_token".path;
    name = "homelab";
    extraLabels = [ "homelab-nix" ];
    replace = true;
    extraPackages = with pkgs; [
      cachix
      jq
      nixfmt-rfc-style
    ];
  };
}
