{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.git;
in {
  options = {
    modules.git = {
      enable = mkEnableOption "Enable git config";

      gh.enable = mkOption {
        type = types.bool;
        description = "Enable GitHub CLI";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.gh = mkIf cfg.gh.enable {
      enable = true;

      settings = {
        git_protocol = "ssh";
        prompt = "enabled";

        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    programs.git = {
      enable = true;
      userName = "Jakob Ankarhem";
      userEmail = "jakob@ankarhem.dev";

      signing = {
        signByDefault = true;
        key = "0x529972E4160200DF";
      };

      extraConfig = {
        init.defaultBranch = "main";
        # Configure Git to ensure line endings in files you checkout are correct for macOS
        core.autocrlf = "input";

        merge.tool = "nvimdiff2";

        # Default to git pull --rebase
        pull.rebase = true;
        # Automatically --set-upstream if not set
        push.autoSetupRemote = true;

        diff.external = "${pkgs.difftastic}/bin/difft";
      };
    };
  };
}
