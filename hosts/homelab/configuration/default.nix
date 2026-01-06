# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  self,
  modulesPath,
  hostname,
  ...
}:
{
  imports = [
    "${self}/nixosModules/networking.nix"
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    ./apps/default.nix
    ./tailscale.nix
    ./fail2ban.nix
  ];
  networking.custom = {
    homelabIp = "192.168.1.221";
    synologyIp = "192.168.1.163";
    lanNetwork = "192.168.1.0/24";
  };

  networking.hostName = hostname; # Define your hostname.
  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = "${self}/secrets/homelab/secrets.yaml";
    age = {
      keyFile = "/home/idealpink/.config/sops/age/keys.txt";
    };
  };

  proxmoxLXC = {
    manageNetwork = true;
  };
  boot.isContainer = true;
  system.stateVersion = "24.05"; # Did you read the comment?
}
