{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.ghostty;
in {
  options = {
    modules.ghostty = {
      enable = mkEnableOption "Enable Ghostty";

      username = mkOption {
        type = types.str;
        description = "Username to to place Ghostty configuration";
        default = throw "modules.ghostty.username is required";
      };

      font-size = mkOption {
        type = types.int;
        description = "Font size for Ghostty";
        default = 16;
      };

      theme = mkOption {
        type = types.str;
        description = "Theme for Ghostty";
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    homebrew.casks = ["ghostty"];

    home-manager.users."${cfg.username}" = {
      home.file.ghostty = {
        target = ".config/ghostty/config";
        text = ''
          font-size = ${toString cfg.font-size}
          theme = ${cfg.theme}
        '';
      };
    };
  };
}
