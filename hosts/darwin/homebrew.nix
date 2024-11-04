{
  inputs,
  username,
  ...
}: let
  inherit (inputs) homebrew-core homebrew-cask homebrew-bundle;
in {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      # this sucks, as the entire homebrew does. gah
      autoUpdate = true;
      upgrade = true;
    };

    global.autoUpdate = false;
    global.brewfile = true;

    masApps = {
    };

    brews = [
      "pinentry-mac"
    ];

    caskArgs.no_quarantine = true;
    casks = [
      "1password"
      "1password-cli"
      "betterdisplay"
      "firefox"
      "google-chrome"
      "legcord"
      "maccy"
      "microsoft-excel"
      "microsoft-remote-desktop"
      "microsoft-teams"
      "mos"
      "kitty"
      "openvpn-connect"
      "raycast"
      "runelite"
      "steam"
      "telegram"
    ];
  };

  nix-homebrew = {
    autoMigrate = true;

    enable = true;
    enableRosetta = true;

    # TODO: Move this to dynamic username
    user = username;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };

    mutableTaps = false;
  };
}
