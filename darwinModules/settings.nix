{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.darwin.settings;
in {
  options = {
    darwin.settings = {
      enable = mkEnableOption "my macOS settings";

      safari.showDevelopMenu = mkOption {
        type = types.bool;
        description = mdDoc "Enable Safari developer menu";
        default = true;
      };

      calendar.showWeekNumbers = mkOption {
        type = types.bool;
        description = mdDoc "Show week numbers in Calendar";
        default = true;
      };

      finder = {
        enableICloudDrive = mkOption {
          type = types.bool;
          description = mdDoc "Enable iCloud Drive integration";
          default = true;
        };
        sortFoldersFirst = mkOption {
          type = types.bool;
          description = mdDoc "Sort folders before files in Finder";
          default = true;
        };
        preferredViewStyle = mkOption {
          type = types.str;
          description = mdDoc "Default file layout in finder";
          default = "Nlsv";
        };
      };

      services.dsStore = mkOption {
        type = types.bool;
        description = mdDoc "Create .DS_Store files on network or USB volumes";
        default = false;
      };

      windowManager.tiledWindowMargins = mkOption {
        type = types.bool;
        description = mdDoc "Enable tiled window margins";
        default = false;
      };

      hotkeys = {
        spotlight.enable = mkOption {
          type = types.bool;
          description = mdDoc "Enable Spotlight search on cmd+space";
          default = false;
        };
        languageSwitch.enable = mkOption {
          type = types.bool;
          description = mdDoc "Enable language switching on ctrl+space";
          default = false;
        };
      };

      linkHomeManagerApps = mkOption {
        type = types.bool;
        description = mdDoc "Linkup ~/Applications/Home Manager Apps to /Applications";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    system.defaults.CustomUserPreferences = {
      "com.apple.Safari.SandboxBroker" = {
        ShowDevelopMenu = cfg.safari.showDevelopMenu;
        WebKitDeveloperExtrasEnabledPreferenceKey = cfg.safari.showDevelopMenu;
      };

      "com.apple.ical" = {
        "Show Week Numbers" = cfg.calendar.showWeekNumbers;
      };
      "com.apple.finder" = {
        FXICloudDriveDesktop = cfg.finder.enableICloudDrive;
        FXICloudDriveDocuments = cfg.finder.enableICloudDrive;
        _FXSortFoldersFirst = cfg.finder.sortFoldersFirst;
        FXPreferredViewStyle = cfg.finder.preferredViewStyle;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = cfg.services.dsStore;
        DSDontWriteUSBStores = cfg.services.dsStore;
      };

      "com.apple.WindowManager" = {
        EnableTiledWindowMargins = cfg.windowManager.tiledWindowMargins;
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

    system.activationScripts = mkIf cfg.linkHomeManagerApps {
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
  };
}
