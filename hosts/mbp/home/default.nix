{ pkgs, inputs, username, helpers, ... }: {
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
    SOPS_AGE_KEY_FILE = "/Users/ankarhem/.config/sops/age/keys.txt";
  };

  imports = [
    ../../../presets/fish.nix
    ../../../presets/gpg.nix
    ../../../presets/neovim/default.nix
    ./karabiner.nix
    ./npm.nix
    ./ssh.nix
    ./vscode.nix
    ./ghostty.nix
    inputs.nix-index-database.hmModules.nix-index
    ../../../homeManagerModules/default.nix
  ];

  modules.git.enable = true;
  home.file.".config/git/allowed_signers".text = let
    authorizedKeys = helpers.ssh.getGithubKeys {
      username = "ankarhem";
      sha256 = "1kjsr54h01453ykm04df55pa3sxj2vrmkwb1p8fzgw5hzfzh3lg0";
    };
    allowedSigners = builtins.concatStringsSep "\n"
      (builtins.map (key: "* ${key}") authorizedKeys);
  in allowedSigners;
  programs.git = {
    signing = { key = "~/.ssh/id_ed25519.pub"; };
    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

  modules.custom-scripts.enable = true;

  programs.nix-index-database = { comma.enable = true; };
  programs.nix-index.enable = true;

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
    # nfs-utils
    nodejs_22
    deno
    imagemagick
    k9s
    mitmproxy
    sops
    age
    tailscale

    alejandra

    mas
    slack
    element-desktop
    spotify
    bruno
    jetbrains.rider
    jetbrains.rust-rover
    jetbrains.webstorm
  ];
  programs.nh = {
    enable = true;
    flake = "/Users/${username}/nix-config";
  };

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

      function copy-term-info
        infocmp -x | ssh $argv[1] -- tic -x -
      end
    '';
  };
  programs.zoxide = { enable = true; };
  programs.eza.enable = true;
  programs.starship = { enable = true; };

  programs.go = {
    enable = true;
    goPath = ".go";
  };
}
