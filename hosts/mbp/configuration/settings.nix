{ self, pkgs, pkgs-unstable, ... }: {
  imports = [ "${self}/darwinModules/default.nix" ];
  darwin.settings.enable = true;

  services = {
    karabiner-elements = {
      enable = true;
      package = pkgs.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";
        src = pkgs.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
        dontFixup = true;
      });
    };
  };

  security.pam.services.sudo_local.touchIdAuth = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock = {
      autohide = false;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;

      persistent-apps = [
        "${pkgs-unstable.element-desktop}/Applications/Element.app/"
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
        "${pkgs.jetbrains.webstorm}/Applications/WebStorm.app/"
        "${pkgs.slack}/Applications/Slack.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "${pkgs.vscode}/Applications/Visual Studio Code.app/"
        "/Applications/1Password.app/"
        "/Applications/Bitwarden.app/"
        "/Applications/Firefox Developer Edition.app/"
        "/Applications/Firefox.app/"
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
