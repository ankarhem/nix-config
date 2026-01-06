{
  self,
  hostname,
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

  sops.defaultSopsFile = "${self}/secrets/workstation/secrets.yaml";

  system.stateVersion = "25.11"; # Did you read the comment?
}
