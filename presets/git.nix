{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    signing = {
      signByDefault = true;
      key = lib.mkDefault "0x529972E4160200DF";
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
}
