{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    protontricks.enable = true;
  };
  # https://nixos.wiki/wiki/Gamemode#Steam
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = with pkgs; [
    lutris
    protonup-qt # Manage Proton versions
  ];
}
