# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  username,
  hostname,
  ...
}: {
  imports = [
  ];

  wsl = {
    enable = true;
    defaultUser = username;

    usbip = {
      enable = true;
      autoAttach = [ "1-6" ];
    };

    useWindowsDriver = true;
    nativeSystemd = true;

    wslConf.automount.root = "/mnt";
    wslConf.interop.appendWindowsPath = false;
    wslConf.network.generateHosts = false;
    wslConf.user.default = username;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = false;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  services.pcscd.enable = true;
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };

  environment.variables = {
    EDITOR = "nvim";
    GNUPGHOME = "~/.gnupg";
    LESS = "-r";
    KEYID = "529972E4160200DF";
  };

  environment.enableAllTerminfo = true;
  security.sudo.wheelNeedsPassword = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      trusted-users = [username];
      experimental-features = ["nix-command" "flakes"];
      # auto-optimise-store = true;
    };
  };

  networking.hostName = hostname; # Define your hostname.

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    git
    wget
    curl
    dig
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  fonts = {
    packages = with pkgs; [
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
