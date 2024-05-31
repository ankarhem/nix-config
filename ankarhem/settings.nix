{pkgs, ...}: {
  # -- MacOS Settings --
  security.pam.enableSudoTouchIdAuth = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
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
  services.nix-daemon.enable = true;
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    # default to column view in finder
    finder.FXPreferredViewStyle = "clmv";
    dock.autohide = false;
    # Don’t rearrange spaces based on the most recent use
    dock.mru-spaces = false;
    screensaver.askForPasswordDelay = 10;
    screencapture.location = "~/Pictures/screenshots";
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
  };
}
