{
  self,
  pkgs,
  pkgs-darwin,
  ...
}:
{
  imports = [
    ./environment.nix
    ./settings.nix
    ./sops.nix
    ./user.nix
  ];

  services.tailscale.enable = true;
  services.tailscale.overrideLocalDns = true;
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];

  # backwards compat; don't change
  system.stateVersion = 5;
}
