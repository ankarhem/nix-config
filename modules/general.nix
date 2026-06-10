{ inputs, ... }:
{
  flake.modules.nixos.general = {
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

    home-manager.sharedModules = [
      inputs.self.modules.homeManager.general
    ];
  };

  flake.modules.darwin.general =
    { pkgs, ... }:
    {
      environment = {
        pathsToLink = [ "/Applications" ];
      };

      homebrew.casks = [
        "1password"
        "1password-cli"
        "azure-data-studio"
        "bitwarden"
        "microsoft-excel"
        "microsoft-remote-desktop"
        "pairpods"
        # "runelite"
        "sikarugir"
        "steam"
        "tailscale"
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
          persistent-apps = [
            "${pkgs._unstable.obsidian}/Applications/Obsidian.app/"
            "${pkgs._unstable.spotify}/Applications/Spotify.app/"
            "/Applications/1Password.app/"
            "/Applications/Bitwarden.app/"
            "/Applications/Microsoft Excel.app/"
            "/System/Applications/Calendar.app/"
            "/System/Applications/Mail.app/"
            "/System/Applications/System Settings.app/"
          ];
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
              # Disable Siri shortcut
              "176" = {
                enabled = false;
              };
            };
          };
        };
      };

      home-manager.sharedModules = [
        inputs.self.modules.homeManager.general
      ];
    };

  flake.modules.homeManager.general =
    { lib, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          google-chrome
          _unstable.obsidian
          _unstable.slack
          _unstable.spotify
        ]
        ++ (lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            _1password-cli
            _1password-gui
            azuredatastudio
            # _unstable.bitwarden-desktop
            phoronix-test-suite
            runelite
            bolt-launcher
            tor-browser
          ]
        ))
        ++ (lib.optionals pkgs.stdenv.isDarwin (
          with pkgs;
          [
            betterdisplay
            maccy
            mos
            _unstable.orbstack
            pinentry_mac
          ]
        ));
    };
}
