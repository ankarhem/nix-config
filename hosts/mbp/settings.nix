{
  pkgs,
  pkgs-unstable,
  ...
}: {
  programs = {
    zsh.enable = true;
    fish.enable = true;
  };

  nixpkgs.overlays = [
    (self: super: {
      karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
        version = "14.13.0";

        src = super.fetchurl {
          inherit (old.src) url;
          hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
        };
      });
    })
  ];
  services = {
    karabiner-elements = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs;
      [
        # packages = with pkgs; [
        # icon fonts
        material-design-icons
        font-awesome
      ]
      ++ [
        pkgs-unstable.nerd-fonts.symbols-only
        pkgs-unstable.nerd-fonts.fira-code
        pkgs-unstable.nerd-fonts.jetbrains-mono
        pkgs-unstable.nerd-fonts.iosevka
      ];
  };

  security.pam.enableSudoTouchIdAuth = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    # default to list view in finder
    finder.FXPreferredViewStyle = "Nlsv";
    dock = {
      autohide = false;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;

      persistent-apps = [
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
        "/Applications/kitty.app/"
        "/Applications/Ghostty.app/"
        "${pkgs.slack}/Applications/Slack.app/"
        "/Applications/legcord.app/"
        "${pkgs.spotify}/Applications/Spotify.app/"
        "/Applications/Telegram.app/"
        "${pkgs.vscode}/Applications/Visual Studio Code.app/"
        "/Applications/1Password.app/"
        "/Applications/Firefox.app/"
        "/Applications/Microsoft Excel.app/"
        "/Applications/Microsoft Teams.app/"
        "/Applications/OpenVPN Connect/OpenVPN Connect.app/"
        "/System/Applications/Calendar.app/"
        "/System/Applications/Facetime.app/"
        "/System/Applications/Mail.app/"
        "/System/Applications/Maps.app/"
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
