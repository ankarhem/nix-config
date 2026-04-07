{ pkgs, ... }:
let
  inherit (pkgs._unstable) rtk;
in
{
  home.packages = [
    rtk
  ];
  programs.opencode.plugins = {
    "rtk" = "${rtk}/share/rtk/hooks/opencode-rtk.ts";
  };
}
