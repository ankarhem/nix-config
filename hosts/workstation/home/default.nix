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
    ./konsole.nix
    ./plasma.nix
    ./runelite.nix
    ./ghostty.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index-database = {
    comma.enable = true;
  };
  programs.nix-index.enable = true;

  home.packages =
    with pkgs;
    [
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
      nodejs_24
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
      obsidian
    ]
    ++ (with pkgs-unstable; [
      element-desktop
      firefox-devedition
      phoronix-test-suite
    ])
    ++ [
      scriptPkgs.yt-sub
      scriptPkgs.summarize
    ];

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
