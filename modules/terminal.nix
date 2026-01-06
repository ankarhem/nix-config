{ inputs, config, ... }:
{
  flake.modules.darwin.terminal =
    { pkgs, ... }:
    {
      system.defaults.dock.persistent-apps = [
        "${pkgs.ghostty-bin}/Applications/Ghostty.app/"
      ];
    };
  flake.modules.homeManager.terminal =
    { lib, pkgs, ... }:
    {
      programs.starship = {
        enable = true;
      };
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isLinux then pkgs.ghostty else pkgs.ghostty-bin;
        enableFishIntegration = true;

        settings = {
          font-size = if pkgs.stdenv.isLinux then 16 else 12;
          theme = "dark:Catppuccin Frappe,light:Catppuccin Latte";
          shell-integration-features = "ssh-terminfo,ssh-env";
        };
      };

      home.file.".local/share/konsole" =
        let
          catppuccinThemes =
            pkgs.fetchgit {
              url = "https://github.com/catppuccin/konsole";
              rev = "3b64040e3f4ae5afb2347e7be8a38bc3cd8c73a8";
              sha256 = "sha256-d5+ygDrNl2qBxZ5Cn4U7d836+ZHz77m6/yxTIANd9BU=";
            }
            + "/themes";
        in
        lib.mkIf pkgs.stdenv.isLinux {
          source = catppuccinThemes;
          recursive = true;
        };

      programs.konsole = lib.mkIf pkgs.stdenv.isLinux rec {
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
    };
}
