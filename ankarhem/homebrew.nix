{inputs, ...}: let
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
    #global.brewfile = true;

    masApps = {
    };

    brews = [];

    caskArgs.no_quarantine = true;
    casks = [
      "maccy"
      "mos"
      "1password"
      "1password-cli"
      "firefox"
      "spotify"
    ];
  };

  nix-homebrew = {
    autoMigrate = true;

    enable = true;
    enableRosetta = true;

    # TODO: Move this to dynamic username
    user = "ankarhem";

    taps = {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "homebrew/homebrew-bundle" = homebrew-bundle;
    };

    mutableTaps = false;
  };
}
