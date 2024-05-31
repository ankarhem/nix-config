{pkgs, ...}: {
  home.stateVersion = "23.11";

  imports = [
    ./karabiner.nix
  ];

  home.packages = with pkgs; [
    wget
    curl
    alejandra
    coreutils
    ripgrep
    htop
    curl
    jq
    (lib.hiPrio gitAndTools.gitFull)
    rustup
    teams
    mas
    slack
    spotify
  ];
  programs.eza.enable = true;

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      jnoortheen.nix-ide
      kamadorueda.alejandra
    ];
    userSettings = {
      # Neovim integration
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      # Nix settings
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "alejandra.program" = "alejandra";

      # Font settings
      "editor.fontSize" = 14;
      "editor.fontFamily" = "Iosevka Nerd Font";
      "terminal.integrated.fontSize" = 14;
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 16;
    };
    theme = "Github";
    shellIntegration = {
      enableFishIntegration = true;
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Jakob Ankarhem";
    userEmail = "jakob@ankarhem.dev";

    extraConfig = {
      push = {autoSetupRemote = true;};
      diff = {external = "${pkgs.difftastic}/bin/difft";};
    };
  };
}
