{
  config,
  pkgs,
  lib,
  ...
}:
let
  catppuccinThemes =
    pkgs.fetchgit {
      url = "https://github.com/catppuccin/konsole";
      rev = "3b64040e3f4ae5afb2347e7be8a38bc3cd8c73a8";
      sha256 = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
    }
    + "/themes";
in
{
  home.file.".local/share/konsole" = {
    source = catppuccinThemes;
    recursive = true;
  };

  programs.konsole = rec {
    enable = true;
    defaultProfile = "catppuccin";

    profiles.${defaultProfile} = {
      colorScheme = "catppuccin-frappe";
      font = {
        name = "Fira Code Nerd Font";
        size = 12;
      };
    };
  };
}
