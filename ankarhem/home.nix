{ pkgs, ... }:
{
  home.stateVersion = "23.11";

  imports = [
  ];

  home.packages = with pkgs; [
    coreutils
    ripgrep
    htop
    curl
    jq
    (lib.hiPrio gitAndTools.gitFull)
    rustup
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
    ];
    userSettings = {
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };
    };
  };

  programs.kitty = {
    enable = true;
  };

  programs.starship = {
    enable = true;
  };

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
