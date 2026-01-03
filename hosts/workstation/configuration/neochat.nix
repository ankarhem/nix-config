{ pkgs, ... }:
{
  # temporary allow olm-3.2.16 as insecure package
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];

  environment.systemPackages = [
    pkgs.kdePackages.neochat
  ];
}
