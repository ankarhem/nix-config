{ inputs, lib, ... }:
{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    let
      inherit (pkgs.nur.repos.rycee) firefox-addons;
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
          DisableAccounts = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
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
                    {
                      name = "Happy";
                      url = "https://app.happy.engineering";
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

            settings = {
              "app.shield.optoutstudies.enabled" = false;
              "browser.bookmarks.addedImportButton" = true;
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.disableResetPrompt" = true;
              "browser.discovery.enabled" = false;
              "browser.download.panel.shown" = true;
              "browser.download.useDownloadDir" = false;
              "browser.feeds.showFirstRunUI" = false;
              "browser.messaging-system.whatsNewPanel.enabled" = false;
              "browser.newtabpage.activity-stream.feeds.telemetry" = false;
              "browser.newtabpage.activity-stream.feeds.topsites" = false;
              "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts" = false;
              "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
              "browser.newtabpage.activity-stream.telemetry" = false;
              "browser.ping-centre.telemetry" = false;
              "browser.profiles.enabled" = false;
              "browser.rights.3.shown" = true;
              "browser.shell.checkDefaultBrowser" = false;
              "browser.shell.defaultBrowserCheckCount" = 1;
              "browser.startup.homepage" = "about:home";
              "browser.startup.homepage_override.mstone" = "ignore";
              "browser.tabs.inTitlebar" = 2;
              "browser.theme.content-theme" = 2;
              "browser.theme.toolbar-theme" = 2;
              "browser.uitour.enabled" = false;
              "browser.uiCustomization.state" = builtins.readFile ./browser.uiCustomization.state.json;
              "datareporting.healthreport.service.enabled" = false;
              "datareporting.healthreport.uploadEnabled" = false;
              "datareporting.policy.dataSubmissionEnabled" = false;
              "datareporting.sessions.current.clean" = true;
              "devtools.onboarding.telemetry.logged" = false;
              "dom.security.https_only_mode" = true;
              "extensions.activeThemeID" = "default-theme@mozilla.org";
              "extensions.pocket.enabled" = false;
              "identity.fxaccounts.enabled" = false;
              "privacy.trackingprotection.enabled" = true;
              "privacy.trackingprotection.socialtracking.enabled" = true;
              "sidebar.revamp" = true;
              "sidebar.verticalTabs" = true;
              "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
              "signon.rememberSignons" = false;
              "startup.homepage_override_url" = "";
              "toolkit.telemetry.archive.enabled" = false;
              "toolkit.telemetry.bhrPing.enabled" = false;
              "toolkit.telemetry.enabled" = false;
              "toolkit.telemetry.firstShutdownPing.enabled" = false;
              "toolkit.telemetry.hybridContent.enabled" = false;
              "toolkit.telemetry.newProfilePing.enabled" = false;
              "toolkit.telemetry.prompted" = 2;
              "toolkit.telemetry.rejected" = true;
              "toolkit.telemetry.reportingpolicy.firstRun" = false;
              "toolkit.telemetry.server" = "";
              "toolkit.telemetry.shutdownPingSender.enabled" = false;
              "toolkit.telemetry.unified" = false;
              "toolkit.telemetry.unifiedIsOptIn" = false;
              "toolkit.telemetry.updatePing.enabled" = false;
              "trailhead.firstrun.didSeeAboutWelcome" = true;
              "widget.gtk.global-menu.enabled" = true;
              "widget.gtk.global-menu.wayland.enabled" = true;
            };
          };
          work =
            let
              firstBookmarkGroup = (builtins.elemAt default.bookmarks.settings 0);
            in
            lib.recursiveUpdate default {
              id = 1;
              name = "dev-edition-default";
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
    };
}
