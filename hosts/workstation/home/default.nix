{
  self,
  helpers,
  pkgs,
  pkgs-unstable,
  scriptPkgs,
  username,
  inputs,
  ...
}:
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";
}
