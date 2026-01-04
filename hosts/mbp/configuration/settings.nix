{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ "${self}/darwinModules/default.nix" ];
  darwin.settings.enable = true;

  security.pam.services.sudo_local.touchIdAuth = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  system.keyboard.userKeyMapping = [
    {
      # Right Command to Option
      HIDKeyboardModifierMappingSrc = 30064771303;
      HIDKeyboardModifierMappingDst = 30064771302;
    }
  ];

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock = {
      autohide = false;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;

      persistent-apps = [
        "${pkgs-unstable.element-desktop}/Applications/Element.app/"
        "${pkgs-unstable.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs-unstable.jetbrains.rust-rover}/Applications/RustRover.app/"
        "${pkgs-unstable.jetbrains.webstorm}/Applications/WebStorm.app/"
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.obsidian}/Applications/Obsidian.app/"
        "${pkgs.slack}/Applications/Slack.app/"
        # "${pkgs.spotify}/Applications/Spotify.app/"
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
    screensaver.askForPasswordDelay = 10;
    screencapture.location = "~/Pictures/screenshots";

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      # show hidden files
      AppleShowAllFiles = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };
}
