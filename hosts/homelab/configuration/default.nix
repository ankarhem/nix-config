# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  self,
  modulesPath,
  pkgs,
  username,
  hostname,
  helpers,
  ...
}:
{
  imports = [
    "${self}/nixosModules/networking.nix"
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./apps/default.nix
    ./sops.nix
    ./tailscale.nix
    ./fail2ban.nix
  ];
  networking.custom = {
    homelabIp = "192.168.1.221";
    synologyIp = "192.168.1.163";
    lanNetwork = "192.168.1.0/24";
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
    };
  };
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.publish = {
    enable = true;
    addresses = true;
  };

  proxmoxLXC = {
    manageNetwork = true;
  };
  boot.isContainer = true;
  networking.hostName = hostname; # Define your hostname.
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "docker"
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
