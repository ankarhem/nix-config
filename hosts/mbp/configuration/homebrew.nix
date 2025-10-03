{
  config,
  inputs,
  username,
  ...
}:
let
  inherit (inputs)
    homebrew-core
    homebrew-cask
    homebrew-bundle
    homebrew-sikarugir
    ;
in
{
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

    masApps = { };

    brews = [ "pinentry-mac" ];

    caskArgs.no_quarantine = true;
    casks = [
      "1password"
      "1password-cli"
      "azure-data-studio"
      "betterdisplay"
      "bitwarden"
      "cursor"
      "firefox"
      "firefox@developer-edition"
      "ghostty"
      "google-chrome"
      "legcord"
      "maccy"
      "microsoft-excel"
      "microsoft-remote-desktop"
      "microsoft-teams"
      "mos"
      "openvpn-connect"
      "orbstack"
      "raycast"
      "runelite"
      "sikarugir"
      "steam"
      "telegram"
    ];
  };

  nix-homebrew = {
    autoMigrate = true;

    enable = true;
    enableRosetta = true;

    user = username;

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
      "Sikarugir-App/homebrew-sikarugir" = homebrew-sikarugir;
    };

    mutableTaps = false;
  };

  homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
}
