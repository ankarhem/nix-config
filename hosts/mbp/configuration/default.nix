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
  system.primaryUser = username;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${username}" = {
    home = "/Users/${username}";
    description = username;
    shell = pkgs.fish;
  };

  sops = {
    defaultSopsFile = "${self}/secrets/mbp/secrets.yaml";
    age = {
      keyFile = "/Users/${username}/.config/sops/age/keys.txt";
    };
  };
  # backwards compat; don't change
  system.stateVersion = 5;
}
