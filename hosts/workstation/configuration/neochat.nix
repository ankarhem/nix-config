{ pkgs, pkgs-unstable, ... }:
{
  environment.systemPackages = [
    pkgs-unstable.kdePackages.neochat
  ];
}
