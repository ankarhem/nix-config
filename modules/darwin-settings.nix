{
  flake.modules.darwin.settings = {
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
            enabled = cfg.hotkeys.spotlight.enable;
          };
          # Disable language switching with ctrl+space
          "60" = {
            enabled = cfg.hotkeys.languageSwitch.enable;
          };
        };
      };
    };
  };
}
