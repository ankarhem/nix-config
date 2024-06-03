{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    extraConfig = {
      # Configure Git to ensure line endings in files you checkout are correct for macOS
      core.autocrlf = "input";
      user = {
        signingKey = "0x529972E4160200DF";
      };
      commit = {
        gpgsign = true;
      };
      push = {autoSetupRemote = true;};
      diff = {external = "${pkgs.difftastic}/bin/difft";};
    };
  };
}
