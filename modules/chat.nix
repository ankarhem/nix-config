{
  lib,
  inputs,
  config,
  ...
}:
{
  flake.modules.nixos.chat = {
    # Linux config: setup OpenSSH server, firewall-ports, etc.
  };

  flake.modules.darwin.chat = {
    homebrew.casks = [
      "legcord"
      "microsoft-teams"
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
