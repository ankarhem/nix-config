{ pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.runelite
    pkgs-unstable.bolt-launcher
  ];
}
