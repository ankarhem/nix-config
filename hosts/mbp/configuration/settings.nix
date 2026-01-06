{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  system.defaults = {
    dock = {
      persistent-apps = [
        "${pkgs-unstable.element-desktop}/Applications/Element.app/"
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.obsidian}/Applications/Obsidian.app/"
        "${pkgs.slack}/Applications/Slack.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "${pkgs.vscode}/Applications/Visual Studio Code.app/"
        "/Applications/1Password.app/"
        "/Applications/Bitwarden.app/"
        "${pkgs.firefox-devedition}/Applications/Firefox Developer Edition.app/"
        "${pkgs.firefox}/Applications/Firefox.app/"
        "/Applications/Ghostty.app/"
        "/Applications/Microsoft Excel.app/"
        "/Applications/Microsoft Teams.app/"
        "/Applications/OpenVPN Connect/OpenVPN Connect.app/"
        "/Applications/legcord.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/Messages.app/"
        "/System/Applications/Notes.app/"
        "/System/Applications/Photos.app/"
        "/System/Applications/System Settings.app/"
      ];
    };
  };
}
