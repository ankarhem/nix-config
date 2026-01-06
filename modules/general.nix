{ inputs, config, ... }:
{
  flake.modules.nixos.general = {
    programs.thunderbird = {
      enable = true;
      preferences = {
        "widget.gtk.global-menu.enabled" = true;
        "widget.gtk.global-menu.wayland.enabled" = true;
      };
    };
  };

  nixpkgs.overlays = [
    (
      final: prev:
      let
        pkgs = import inputs.nixpkgs {
          inherit (prev) system config;
        };
      in
      {
        spotify = pkgs.spotify.overrideAttrs (oldAttrs: {
          src = pkgs.fetchurl {
            url = "https://web.archive.org/web/20251029235406/https://download.scdn.co/SpotifyARM64.dmg";
            hash = "sha256-gEZxRBT7Jo2m6pirf+CreJiMeE2mhIkpe9Mv5t0RI58=";
          };
        });
      }
    )
  ];
  flake.modules.darwin.general =
    { pkgs, ... }:
    {
      system.defaults.dock.persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/1Password.app/"
        "/Applications/Bitwarden.app/"
        "/Applications/Microsoft Excel.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/System Settings.app/"
      ];

      homebrew.casks = [
        "1password"
        "1password-cli"
        "azure-data-studio"
        "betterdisplay"
        "bitwarden"
        "cursor"
        "ghostty"
        "google-chrome"
        "maccy"
        "microsoft-excel"
        "microsoft-remote-desktop"
        "mos"
        "orbstack"
        "pairpods"
        "runelite"
        "sikarugir"
        "steam"
        "tor-browser"
      ];
    };

  flake.modules.homeManager.general =
    { lib, pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          obsidian
          slack
          spotify
        ]
        ++ lib.optionals pkgs.stdenv.isLinux (
          with pkgs;
          [
            _1password-gui
            bitwarden-desktop
            phoronix-test-suite
            runelite
            bolt-launcher
          ]
        );
    };
}
