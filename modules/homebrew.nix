{
  inputs,
  ...
}:
let
  username = "ankarhem";
  inherit (inputs)
    homebrew-core
    homebrew-cask
    homebrew-bundle
    homebrew-sikarugir
    ;
in
{
  flake.modules.darwin.homebrew =
    { config, ... }:
    {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
      ];

      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "uninstall";
          autoUpdate = true;
          upgrade = true;
        };

        global.autoUpdate = false;
        global.brewfile = true;

        greedyCasks = true;
        # caskArgs.no_quarantine = true;
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
    };
}
