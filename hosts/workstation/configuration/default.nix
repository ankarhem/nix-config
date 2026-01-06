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
    ./gaming.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.enableAllFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  networking.hostName = hostname; # Define your hostname.

  sops = {
    defaultSopsFile = "${self}/secrets/workstation/secrets.yaml";
    age = {
      keyFile = "/home/idealpink/.config/sops/age/keys.txt";
    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}
