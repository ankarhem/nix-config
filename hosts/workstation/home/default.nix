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
    ./runelite.nix
  ];

  home.packages =
    with pkgs;
    [
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
}
