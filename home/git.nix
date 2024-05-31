{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    extraConfig = {
      user = {
        signingKey = "0x529972E4160200DF";
      };
      # gpg = {
      #   format = "ssh";
      # };
      # "gpg \"ssh\"" = {
      #   program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      # };
      commit = {
        gpgsign = true;
      };
      push = {autoSetupRemote = true;};
      diff = {external = "${pkgs.difftastic}/bin/difft";};
    };
  };
}
