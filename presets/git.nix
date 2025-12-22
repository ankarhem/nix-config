{ pkgs, lib, ... }:
{
  programs.git = {
    enable = true;

    signing = {
      signByDefault = true;
      key = lib.mkDefault "0x529972E4160200DF";
    };

    settings = {
      user = {
        name = "Jakob Ankarhem";
        email = "jakob@ankarhem.dev";
      };
      init.defaultBranch = "main";
      # Configure Git to ensure line endings in files you checkout are correct for macOS
      core.autocrlf = "input";

      merge.tool = "nvimdiff2";
      mergetool.hideResolved = true;
      mergetool.keepBackup = false;

      # Default to git pull --rebase
      pull.rebase = true;
      # Automatically --set-upstream if not set
      push.autoSetupRemote = true;

      diff.external = "${pkgs.difftastic}/bin/difft";
    };
  };
}
