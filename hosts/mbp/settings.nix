{
  pkgs,
  pkgs-stable,
  ...
}: {
  system.activationScripts = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

      # Check if ~/Applications/Home\ Manager\ Apps exists and symlink directory to /Applications
      HMA_DIRECTORY_SOURCE=~/Applications/Home\ Manager\ Apps
      HMA_DIRECTORY_TARGET=/Applications
      if [ -d "$HMA_DIRECTORY_SOURCE" ] && [ ! -L "$HMA_DIRECTORY_TARGET/Home Manager Apps" ]; then
        echo "Symlinking ~/Applications/Home\ Manager\ Apps directory to /Applications"
        ln -s "$HMA_DIRECTORY_SOURCE" "$HMA_DIRECTORY_TARGET"
      fi
    '';
  };

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  # -- MacOS Settings --
  security.pam.enableSudoTouchIdAuth = true;

  services = {
    karabiner-elements = {
      enable = true;
      package = pkgs-stable.karabiner-elements;
    };
  };

  fonts = {
    packages = with pkgs; [
      # packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    # default to list view in finder
    finder.FXPreferredViewStyle = "Nlsv";
    dock = {
      autohide = false;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;

      persistent-apps = [
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
        "/Applications/kitty.app/"
        "${pkgs.slack}/Applications/Slack.app/"
        "/Applications/legcord.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/Telegram.app/"
        "${pkgs.vscode}/Applications/Visual Studio Code.app/"
        "/Applications/1Password.app/"
        "/Applications/Firefox.app/"
        "/Applications/Microsoft Excel.app/"
        "/Applications/Microsoft Teams.app/"
        "/Applications/OpenVPN Connect/OpenVPN Connect.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Facetime.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/Maps.app/"
        "/System/Applications/Messages.app/"
        "/System/Applications/Notes.app/"
        "/System/Applications/Photos.app/"
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
  };
  system.defaults.CustomUserPreferences = {
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
}
