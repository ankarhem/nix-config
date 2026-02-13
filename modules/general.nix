{ inputs, config, ... }:
let
  nixpkgs.overlays = [
    (
      final: prev:
      let
        pkgs = import inputs.nixpkgs {
          inherit (prev) system config;
        };
      in
      {
        spotify = pkgs.spotify.overrideAttrs (oldAttrs: {
          src = pkgs.fetchurl {
            url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
            hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
          };
        });
      }
    )
  ];
in
{
  flake.modules.nixos.general = {
    inherit nixpkgs;
    programs.thunderbird = {
      enable = true;
      preferences = {
        "widget.gtk.global-menu.enabled" = true;
        "widget.gtk.global-menu.wayland.enabled" = true;
      };
    };

    time.timeZone = "Europe/Stockholm";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocales = [ "sv_SE.UTF-8/UTF-8" ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };

    networking.networkmanager.enable = true;
    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.publish = {
      enable = true;
      addresses = true;
    };
  };

  flake.modules.darwin.general =
    { pkgs, ... }:
    {
      environment = {
        pathsToLink = [ "/Applications" ];
      };
      inherit nixpkgs;
      system.defaults.dock.persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/1Password.app/"
        "/Applications/Bitwarden.app/"
        "/Applications/Microsoft Excel.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/System Settings.app/"
      ];

      homebrew.brews = [
        "pinentry-mac"
      ];
      homebrew.casks = [
        "1password"
        "1password-cli"
        "azure-data-studio"
        "betterdisplay"
        "bitwarden"
        "google-chrome"
        "maccy"
        "microsoft-excel"
        "microsoft-remote-desktop"
        "mos"
        "orbstack"
        "pairpods"
        "runelite"
        "sikarugir"
        "steam"
        "tailscale-app"
        "tor-browser"
      ];

      security.pam.services.sudo_local.touchIdAuth = true;
      system.defaults = {
        finder.AppleShowAllExtensions = true;
        finder._FXShowPosixPathInTitle = true;

        dock = {
          autohide = false;
          # Don’t rearrange spaces based on the most recent use
          mru-spaces = false;
        };
        screensaver.askForPasswordDelay = 10;
        screencapture.location = "~/Pictures/screenshots";

        NSGlobalDomain = {
          AppleShowAllExtensions = true;
          # show hidden files
          AppleShowAllFiles = true;
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 14;
          KeyRepeat = 1;
        };
        CustomUserPreferences = {
          "com.apple.Safari.SandboxBroker" = {
            ShowDevelopMenu = true;
            WebKitDeveloperExtrasEnabledPreferenceKey = true;
          };

          "com.apple.ical" = {
            "Show Week Numbers" = true;
          };
          "com.apple.finder" = {
            FXICloudDriveDesktop = true;
            FXICloudDriveDocuments = true;
            _FXSortFoldersFirst = true;
            FXPreferredViewStyle = "Nlsv";
          };
          "com.apple.desktopservices" = {
            # Avoid creating .DS_Store files on network or USB volumes
            DSDontWriteNetworkStores = true;
            DSDontWriteUSBStores = true;
          };

          "com.apple.WindowManager" = {
            EnableTiledWindowMargins = false;
          };

          "com.apple.symbolichotkeys" = {
            AppleSymbolicHotKeys = {
              # Disable spotlight with cmd+space
              "64" = {
                enabled = false;
              };
              # Disable language switching with ctrl+space
              "60" = {
                enabled = false;
              };
            };
          };
        };
      };
    };

  flake.modules.homeManager.general =
    { lib, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          obsidian
          slack
          spotify
        ]
        ++ lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            _1password-gui
            bitwarden-desktop
            phoronix-test-suite
            runelite
            bolt-launcher
          ]
        );
    };
}
