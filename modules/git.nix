{
  flake.modules.homeManager.git =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      programs.git = {
        enable = true;

        signing = {
          signByDefault = true;
          key = lib.mkDefault "~/.ssh/id_ed25519.pub";
        };

        settings = {
          gpg.format = "ssh";
          user = {
            name = "Jakob Ankarhem";
            inherit (config.constants) email;
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
    };
}
