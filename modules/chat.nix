{
  lib,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.chat = { };

  flake.modules.darwin.chat =
    { pkgs, ... }:
    {
      homebrew.casks = [
        "legcord"
        "microsoft-teams"
      ];

      system.defaults.dock.persistent-apps = [
        "${pkgs.element-desktop}/Applications/Element.app/"
        "${pkgs.slack}/Applications/Slack.app/"
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
          element-desktop
        ]
        ++ lib.optionals pkgs.stdenv.isLinux [
          legcord
          teams-for-linux
        ];
    };
}
