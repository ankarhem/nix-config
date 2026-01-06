{ inputs, config, ... }:
{
  flake.modules.darwin.dev =
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

  flake.modules.homeManager.dev =
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
