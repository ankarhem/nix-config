{
  self,
  pkgs,
  ...
}:
{
  services.tailscale.enable = true;
  services.tailscale.overrideLocalDns = true;
  networking.knownNetworkServices = [
    "USB 10/100/1000 LAN"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];

  networking.hostName = hostname;
  networking.computerName = hostname;

  sops = {
    defaultSopsFile = "${self}/secrets/mbp/secrets.yaml";
    age = {
      keyFile = "/Users/ankarhem/.config/sops/age/keys.txt";
    };
  };
  # backwards compat; don't change
  system.stateVersion = 5;
}
