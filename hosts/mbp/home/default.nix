{
  self,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  inputs,
  username,
  helpers,
  ...
}:
let
in
{
  programs.home-manager.enable = true;
  home.stateVersion = "23.11";
}
