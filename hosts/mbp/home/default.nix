{
  self,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  inputs,
  username,
  helpers,
  ...
}:
let
  spotify = pkgs.spotify.overrideAttrs (oldAttrs: {
    src = pkgs.fetchurl {
      url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
      hash = "sha256-0gwoptqLBJBM0qJQ+dGAZdCD6WXzDJEs0BfOxz7f2nQ=";
    };
  });
in
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.11";
  home.sessionVariables = {
    PATH = "$PATH:$GOPATH/bin";
    SOPS_AGE_KEY_FILE = "/Users/ankarhem/.config/sops/age/keys.txt";
  };

  imports = [
    "${self}/homeManagerModules/scripts.nix"
    "${self}/presets/fish.nix"
    "${self}/presets/gpg.nix"
    "${self}/presets/git.nix"
    "${self}/presets/gh.nix"
    "${self}/presets/neovim/default.nix"
    ./npm.nix
    ./ssh.nix
    ./vscode.nix
    ./ghostty.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home.file.".config/git/allowed_signers".text =
    let
      authorizedKeys = helpers.ssh.getGithubKeys {
        username = "ankarhem";
        sha256 = "1kjsr54h01453ykm04df55pa3sxj2vrmkwb1p8fzgw5hzfzh3lg0";
      };
      allowedSigners = builtins.concatStringsSep "\n" (builtins.map (key: "* ${key}") authorizedKeys);
    in
    allowedSigners;
  programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519.pub";
    };
    settings = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

  modules.custom-scripts.enable = true;

  programs.nix-index-database = {
    comma.enable = true;
  };
  programs.nix-index.enable = true;

  home.packages =
    (with pkgs; [
      openssh
      yubikey-manager
      yubikey-personalization

      git
      age
      alejandra
      bat
      bottom
      codex
      coreutils
      curl
      deno
      fd
      gitleaks
      grc
      htop
      imagemagick
      jq
      k9s
      kubelogin
      mas
      mitmproxy
      ngrok
      nodejs_22
      pup
      ripgrep
      rm-improved
      sops
      tailscale
      tree
      uv # dependency for ddg-mcp
      wget
      (dotnetCorePackages.combinePackages [
        # dotnet-sdk_6
        # dotnet-sdk_7
        dotnet-sdk
        dotnet-sdk_9
        dotnet-sdk_10
      ])

      bruno
      slack
      obsidian
    ])
    ++ (with pkgs-unstable; [
      claude-code
      mcp-nixos
      element-desktop
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.webstorm
    ])
    ++ (with scriptPkgs; [
      yt-sub
      summarize
    ])
    ++ [ spotify ];
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
  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
  programs.starship = {
    enable = true;
  };

  programs.go = {
    enable = true;
    env = {
      GOPATH = ".go";
    };
  };
}
