# hosts/ankarhem/default.nix
{ pkgs, ... }:
{
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
  };

  environment = {
    shells = with pkgs; [ bash zsh fish ];
#    loginShell = pkgs.fish;
    systemPackages = [ pkgs.coreutils ];
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
#  fonts.fontDir.enable = true; # DANGER
#  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
  services.nix-daemon.enable = true;
  system.defaults = {
    finder.AppleShowAllExtensions = true;
    finder._FXShowPosixPathInTitle = true;
    dock.autohide = false;
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.InitialKeyRepeat = 14;
    NSGlobalDomain.KeyRepeat = 1;
  };
  # backwards compat; don't change
  system.stateVersion = 4;
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = { };
    casks = [];
    taps = [];
    brews = [];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ankarhem = { pkgs, ... }: {
    home.stateVersion = "23.11";
    programs.git = {
      enable = true;
      userName = "Jakob Ankarhem";
      userEmail = "jakob@ankarhem.dev";
    };
  };
  users.users.ankarhem = {
    home = "/Users/ankarhem";
    shell = pkgs.fish;
    # need to run manually for now: chsh -s /run/current-system/sw/bin/fish
  };
}
