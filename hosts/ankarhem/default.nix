# hosts/ankarhem/default.nix
{ pkgs, ... }:
{
  # here go the darwin preferences and config items
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
  };
  programs.nixvim = {
    enable = true;
    colorschemes.gruvbox.enable = true;
    options = {
      number = true;
      relativenumber = true;

      shiftwidth = 2;
    };

    plugins = {
      lightline.enable = true;
      telescope.enable = true;
      oil.enable = true;
      treesitter.enable = true;
      luasnip.enable = true;
    };

    plugins.lsp = {
      enable = true;
      servers = {
        tsserver.enable = true;
        lua-ls.enable = true;
        rust-analyzer.enable = true;
      };
    };
  };

  environment.systemPackages = [
    pkgs.coreutils
    pkgs.rustup
  ];
  environment = {
    shells = with pkgs; [ bash zsh fish ];
#    loginShell = pkgs.fish;
    systemPath = [ "/opt/homebrew/bin" ];
    pathsToLink = [ "/Applications" ];
    shellAliases = {
      vim = "nvim";
    };
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  security.pam.enableSudoTouchIdAuth = true;
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
#  fonts.fontDir.enable = true; # DANGER
#  fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];
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
