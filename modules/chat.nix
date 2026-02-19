{
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.chat =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.chat
        {
          home.packages = with pkgs; [
            kdePackages.neochat
          ];
        }
      ];
    };
  flake.modules.darwin.chat =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.chat
      ];
      homebrew.casks = [
        "legcord"
        "microsoft-teams"
      ];
      homebrew.masApps = {
        # "FluffyChat" = 1551469600;
      };
      system.defaults.dock.persistent-apps = [
        "${pkgs.slack}/Applications/Slack.app/"
        "/Applications/FluffyChat.app/"
        "/Applications/Microsoft Teams.app/"
        "/Applications/legcord.app/"
        "/System/Applications/Messages.app/"
      ];
    };

  flake.modules.homeManager.chat =
    { pkgs, ... }:
    {
      home.packages =
        with pkgs;
        [
          slack
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          legcord
          teams-for-linux
        ];
    };
}
