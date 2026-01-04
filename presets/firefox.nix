{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [
      "sv-SE"
      "en-GB"
    ];

    policies = {
      FirefoxHome = {
        SponsoredTopSites = false;
        SponsoredPocket = false;
      };
    };
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Nix Search";
              url = "https://search.nixos.org/packages?query=";
            }
            {
              name = "Home Manager Search";
              url = "https://home-manager-options.extranix.com/?query=";
            }
          ];
        };

        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
          ];
        };

        settings = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          "extensions.activeThemeID" = "default-theme@mozilla.org";
          "browser.theme.content-theme" = 2;
          "browser.theme.toolbar-theme" = 2;
        };
      };
    };
  };
}
