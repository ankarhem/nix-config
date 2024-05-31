{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    extraConfig = {
      user = {
        signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxrxA66YGWmtDzafAlXbnHjQL+ggTdT/HteXoGFSagF";
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      commit = {
        gpgsign = true;
      };
      push = {autoSetupRemote = true;};
      diff = {external = "${pkgs.difftastic}/bin/difft";};
    };
  };
}
