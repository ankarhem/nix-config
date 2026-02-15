{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock = {
      autohide = false;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;

      persistent-apps = [
        "${pkgs.obsidian}/Applications/Obsidian.app/"
        # "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/1Password.app/"
        "/Applications/Bitwarden.app/"
        "/Applications/Ghostty.app/"
        "/Applications/Microsoft Excel.app/"
        "/Applications/OpenVPN Connect/OpenVPN Connect.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/Notes.app/"
        "/System/Applications/Photos.app/"
        "/System/Applications/System Settings.app/"
      ];
    };
    screensaver.askForPasswordDelay = 10;
    screencapture.location = "~/Pictures/screenshots";

    ".GlobalPreferences"."com.apple.mouse.scaling" = 1.25;
    ".GlobalPreferences"."com.apple.mouse.linear" = true;

    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable siri shortcut
          "176" = {
            enabled = 0;
          };
        };
      };
    };

    NSGlobalDomain = {
      "com.apple.mouse.linear" = true;
      AppleShowAllExtensions = true;
      # show hidden files
      AppleShowAllFiles = true;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };
}
