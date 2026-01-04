{ pkgs, inputs, ... }:
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
              name = "NixOS Manual";
              url = "https://nixos.org/manual/nixos/stable/";
            }
            {
              name = "Darwin Configuration";
              url = "https://nix-darwin.github.io/nix-darwin/manual/index.html";
            }
            {
              name = "Github PRs";
              url = "https://github.com/pulls?q=sort%3Aupdated-desc+is%3Apr+is%3Aopen+author%3A%40me+archived%3Afalse";
            }
            {
              name = "Thai (Beginner 0)";
              url = "https://www.youtube.com/playlist?list=PLgdZTyVWfUhlxVi68zFEL8Lu5Q0Bocgbp";
            }
          ];
        };

        search = {
          force = true;
          default = "Kagi";
          engines = {
            "Kagi" = {
              urls = [
                {
                  template = "https://kagi.com/search?q={searchTerms}";
                }
              ];
              definedAliases = [ "@k" ];
            };
            "Google".metaData.alias = "@g";
          };
          order = [
            "Kagi"
            "Noogle"
          ];
        };

        extensions = {
          force = true;
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            consent-o-matic
            dearrow
            dont-track-me-google1
            kagi-search
            libredirect
            multi-account-containers
            plasma-integration
            refined-github
            sponsorblock
            ublock-origin
          ];
        };

        # How to figure out which setting to change:
        # 1. Make a backup of prefs.js:  $ cp ~/.mozilla/firefox/default/{prefs.js,prefs.js.bak}
        # 2. Make a change through Firefox's settings page
        # 3. Compare prefs.js and the backup:  $ meld ~/.mozilla/firefox/default/{prefs.js.bak,prefs.js}
        settings = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          "extensions.activeThemeID" = "default-theme@mozilla.org";
          "browser.theme.content-theme" = 2;
          "browser.theme.toolbar-theme" = 2;

          "browser.toolbars.bookmarks.visibility" = "always";
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

          "extensions.pocket.enabled" = false;
        };
      };
    };
  };
}
