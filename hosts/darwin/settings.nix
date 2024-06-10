{pkgs, ...}: {
  system.activationScripts = {
    # activationScripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
    postUserActivation.text = ''
      # activateSettings -u will reload the settings from the database and apply them to the current session,
      # so we do not need to logout and login again to make the changes take effect.
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  # -- MacOS Settings --
  security.pam.enableSudoTouchIdAuth = true;

  services = {
    karabiner-elements.enable = true;
  };

  fonts = {
    # will be removed after this PR is merged:
    #   https://github.com/LnL7/nix-darwin/pull/754
    fontDir.enable = true;

    # will change to `fonts.packages` after this PR is merged:
    #   https://github.com/LnL7/nix-darwin/pull/754
    fonts = with pkgs; [
      # packages = with pkgs; [
      # icon fonts
      material-design-icons
      font-awesome

      # nerdfonts
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/fonts/nerdfonts/shas.nix
      (nerdfonts.override {
        fonts = [
          # symbols icon only
          "NerdFontsSymbolsOnly"
          # Characters
          "FiraCode"
          "JetBrainsMono"
          "Iosevka"
        ];
      })
    ];
  };

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    # default to list view in finder
    finder.FXPreferredViewStyle = "Nlsv";
    dock.autohide = false;
    # Don’t rearrange spaces based on the most recent use
    dock.mru-spaces = false;
    screensaver.askForPasswordDelay = 10;
    screencapture.location = "~/Pictures/screenshots";

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      # show hidden files
      AppleShowAllFiles = true;
      ApplePressAndHoldEnabled = true;
      InitialKeyRepeat = 14;
      KeyRepeat = 1;
    };
  };
  system.defaults.CustomUserPreferences = {
    "com.apple.ical" = {
      "Show Week Numbers" = true;
    };
    "com.apple.finder" = {
      FXICloudDriveDesktop = true;
      FXICloudDriveDocuments = true;
      _FXSortFoldersFirst = true;
    };
    "com.jetbrains.rider" = {
      ApplePressAndHoldEnabled = false;
    };
    "com.jetbrains.rustrover-EAP" = {
      ApplePressAndHoldEnabled = false;
    };

    "com.apple.desktopservices" = {
      # Avoid creating .DS_Store files on network or USB volumes
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
  };
}
