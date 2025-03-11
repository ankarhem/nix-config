{config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    tailscale
  ];

  sops.secrets.tailscale_auth_key = {};
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale_auth_key.path;
    useRoutingFeatures = "both";
    extraUpFlags = ["--advertise-exit-node" "--advertise-routes=192.168.1.0/24"];
    extraSetFlags = ["--advertise-exit-node" "--advertise-routes=192.168.1.0/24"];
  };
}
