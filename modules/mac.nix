{
  flake.modules.darwin.mac = {
    security.pam.services.sudo_local.touchIdAuth = true;
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
    system.keyboard.userKeyMapping = [
      {
        # Right Command to Option
        HIDKeyboardModifierMappingSrc = 30064771303;
        HIDKeyboardModifierMappingDst = 30064771302;
      }
    ];
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
}
