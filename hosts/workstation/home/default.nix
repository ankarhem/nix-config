{
  self,
  helpers,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  username,
  inputs,
  ...
}:
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  imports = [
    "${self}/homeManagerModules/scripts.nix"
    "${self}/presets/fish.nix"
    "${self}/presets/git.nix"
    "${self}/presets/gh.nix"
    "${self}/presets/gpg.nix"
    "${self}/presets/neovim/default.nix"
    "${self}/presets/vscode.nix"
    ./runelite.nix
    ./ssh.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home.file.".config/git/allowed_signers".text =
    let
      authorizedKeys = helpers.ssh.getGithubKeys {
        username = "ankarhem";
        sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
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
    with pkgs;
    [
      yubikey-personalization
      yubikey-manager
      openssh

      _1password-cli
      age
      alejandra
      azure-cli
      bat
      bottom
      coreutils
      curl
      deno
      fd
      git
      gitleaks
      grc
      htop
      imagemagick
      jq
      k9s
      kubelogin
      mitmproxy
      newt
      nfs-utils
      ngrok
      nodejs_22
      pup
      ripgrep
      rm-improved
      sops
      tailscale
      tree
      uv
      wget

      _1password-gui
      bruno
      bitwarden-desktop
      legcord
      slack
      spotify
      teams-for-linux
      thunderbird
      obsidian
    ]
    ++ (with pkgs-unstable; [
      mcp-nixos
      element-desktop
      jetbrains.rider
      jetbrains.rust-rover
      jetbrains.webstorm
      furmark
      mprime
    ])
    ++ (with scriptPkgs; [
      yt-sub
      summarize
    ]);

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
