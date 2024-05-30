{ pkgs, ... }:
{
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    htop
    curl
    coreutils
    jq
#    gitAndTools.gitFull
    rustup
  ];

  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    extraConfig = {
      push = { autoSetupRemote = true; };
      diff = { external = "${pkgs.difftastic}/bin/difft"; };
    };
  };
}
