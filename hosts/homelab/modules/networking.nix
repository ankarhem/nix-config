{...}:{
  networking.useHostResolvConf = false;
  networking = {
    useDHCP = false;
    useNetworkd = true;
  };

  systemd.network.enable = true;
  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1" "8.8.8.8"];  # Fallback servers if your local DNS fails
    extraConfig = ''
    DNS=127.0.0.1
    '';
  };

  systemd.network.networks."40-wired" = {
    matchConfig.Name = "eth*";
    networkConfig = {
      Address = "192.168.1.222/24";
      Gateway = "192.168.1.1";
      DNS = "127.0.0.1";
      DHCP = "no";
    };
  };
}
