# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  self,
  pkgs,
  username,
  hostname,
  helpers,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./bluetooth.nix
    ./gpu.nix
    ./sops.nix
    ./gaming.nix
    ./comfyui.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  networking.hostName = hostname; # Define your hostname.
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nix-config/";
    clean.enable = true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
  };

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "sv_SE.UTF-8/UTF-8" ];
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
  services.xserver.xkb = {
    layout = "us";
    variant = "colemak";
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "escape";
            leftalt = "leftmeta";
            leftmeta = "leftalt";
            rightalt = "rightmeta";
            rightmeta = "rightalt";
          };
        };
      };
    };
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = "Jakob Ankarhem";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    git
    wget
    curl
    dig
    tree
    wl-clipboard
  ];
  environment.shellAliases = {
    pbcopy = "wl-copy";
    pbpaste = "wl-paste";
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  environment.variables.EDITOR = "nvim";

  programs.thunderbird = {
    enable = true;
    preferences = {
      "widget.gtk.global-menu.enabled" = true;
      "widget.gtk.global-menu.wayland.enabled" = true;
    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
