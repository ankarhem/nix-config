{
  self,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  inputs,
  username,
  helpers,
  ...
}:
let
  spotify = pkgs.spotify.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
    };
  });
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
    SOPS_AGE_KEY_FILE = "/Users/ankarhem/.config/sops/age/keys.txt";
  };

  home.packages =
    (with pkgs; [
      bruno
      slack
      obsidian
    ])
    ++ (with pkgs-unstable; [
      element-desktop
    ])
    ++ (with scriptPkgs; [
      yt-sub
      summarize
    ])
    ++ [ spotify ];
}
