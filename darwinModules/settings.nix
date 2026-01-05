{ config, lib, ... }:
with lib;
let
  cfg = config.darwin.settings;
in
{
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
  };
}
