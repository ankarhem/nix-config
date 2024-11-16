args @ {
  pkgs,
  inputs,
  username,
  ...
}: {
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
  };

  imports = [
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/gpg/default.nix
    ../../modules/neovim/default.nix
    ./modules/karabiner.nix
    ./modules/npm.nix
    ./modules/ssh.nix
    ./modules/vscode.nix
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
    deno

    alejandra

    mas
    slack
    spotify
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
    loginShellInit = ''
      fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin

      function secret
        set output (string join . $argv[1] (date +%s) enc)
        gpg --encrypt --armor --output $output -r $KEYID $argv[1]
        and echo "$argv[1] -> $output"
      end

      function reveal
        set output (echo $argv[1] | rev | cut -c16- | rev)
        gpg --decrypt --output $output $argv[1]
        and echo "$argv[1] -> $output"
      end
    '';
  };
  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
  programs.starship = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 16;
    };
    themeFile = "Alabaster";
    shellIntegration = {
      enableFishIntegration = true;
    };
  };

  programs.go = {
    enable = true;
    goPath = ".go";
  };
}
