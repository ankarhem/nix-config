{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  firefox-addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
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
    profiles = rec {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        bookmarks = {
          force = true;
          settings = [
            {
              name = "Bookmarks Toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "NixOS Manual";
                  url = "https://nixos.org/manual/nixos/stable/";
                }
                {
                  name = "Darwin Configuration";
                  url = "https://nix-darwin.github.io/nix-darwin/manual/index.html";
                }
              ];
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
          packages = with firefox-addons; [
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

        # diff prefs.js
        settings = {
          "widget.gtk.global-menu.enabled" = true;
          "widget.gtk.global-menu.wayland.enabled" = true;
          "extensions.activeThemeID" = "default-theme@mozilla.org";
          "browser.theme.content-theme" = 2;
          "browser.theme.toolbar-theme" = 2;
          # New profile management
          "browser.profiles.enabled" = false;

          "browser.uiCustomization.state" = builtins.readFile ./browser.uiCustomization.state.json;
          "sidebar.verticalTabs" = true;
          "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

          "browser.bookmarks.addedImportButton" = true;
          "extensions.pocket.enabled" = false;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
        };
      };
      work =
        let
          firstBookmarkGroup = (builtins.elemAt default.bookmarks.settings 0);
        in
        lib.recursiveUpdate default {
          id = 1;
          name = "work";
          isDefault = false;

          bookmarks = {
            force = true;
            settings = [
              firstBookmarkGroup
            ]
            ++ [
              {
                name = "Atlassian";
                toolbar = true;
                bookmarks = [
                  "separator"
                  {
                    name = "Order Board";
                    url = "https://norce.atlassian.net/jira/software/c/projects/ORD/boards/48";
                  }
                  {
                    name = "Maintenance";
                    url = "https://norce.atlassian.net/wiki/spaces/ORD/pages/277643969/Daily+checks";
                  }
                  {
                    name = "Tempo";
                    url = "https://norce.atlassian.net/plugins/servlet/ac/io.tempo.jira/tempo-app";
                  }
                ];
              }
              {
                name = "Code";
                toolbar = true;
                bookmarks = [
                  "separator"
                  {
                    name = "Norce Checkout";
                    url = "https://github.com/orgs/NorceTech/repositories?language=&q=checkout&sort=&type=all";
                  }
                  {
                    name = "Pending Reviews";
                    url = "https://github.com/search?q=+review-requested%3A%40me+is%3Apr+org%3ANorceTech+state%3Aopen+archived%3Afalse+sort%3Aauthor-date+-author%3Adependabot%5Bbot%5D+-review%3Aapproved+&type=pullrequests&state=open";
                  }
                  {
                    name = "Devin";
                    url = "https://app.devin.ai";
                  }
                ];
              }
              {
                name = "Validate Swedish Personal Identity Numbers";
                url = "https://swedish.identityinfo.net/personalidentitynumber/validate?number=200308302389";
              }
            ];
          };

          extensions = {
            force = true;
            packages =
              (builtins.filter (p: p != firefox-addons.bitwarden) default.extensions.packages)
              ++ (with firefox-addons; [
                onepassword-password-manager
              ]);
          };
        };
    };
  };
}
