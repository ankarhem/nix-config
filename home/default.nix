args @ {
  pkgs,
  inputs,
  username,
  ...
}: {
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
  };

  programs.home-manager.enable = true;

  imports = [
    ./karabiner.nix
    ./ssh.nix
    ./git.nix
    ./gpg/default.nix
    ./vscode.nix
    ./neovim/default.nix
    ./npm.nix
  ];

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    openssh

    coreutils
    wget
    curl
    (lib.hiPrio gitAndTools.gitFull)
    htop
    ripgrep
    rm-improved
    jq
    grc
    gitleaks
    bottom
    bat
    tree
    ngrok
    fd
    nodejs_20

    alejandra

    mas
    slack
    discord
    spotify
    telegram-desktop
    bruno
    jetbrains.rider
    jetbrains.rust-rover
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    # Reorders stuff so that nix can override system binaries
    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

    plugins = with pkgs.fishPlugins; [
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "git-abbr";
        src = git-abbr.src;
      }
      {
        name = "grc";
        src = grc.src;
      }
      {
        name = "colored-man-pages";
        src = colored-man-pages.src;
      }
    ];
  };
  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 16;
    };
    theme = "Alabaster";
    shellIntegration = {
      enableFishIntegration = true;
    };
  };

  programs.starship = {
    enable = true;
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };
}
