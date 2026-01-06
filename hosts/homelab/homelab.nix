{ self }:
let
  hostname = "homelab";
in
{
  system.stateVersion = "24.05"; # Did you read the comment?
  boot.isContainer = true;
  proxmoxLXC = {
    manageNetwork = true;
  };
  imports = [
    "${modulesPath}/virtualisation/proxmox-lxc.nix"
    "${self}/nixosModules/networking.nix"
    ./apps/default.nix
  ];

  networking.custom = {
    homelabIp = "192.168.1.221";
    synologyIp = "192.168.1.163";
    lanNetwork = "192.168.1.0/24";
  };

  networking.hostName = hostname;
  sops.defaultSopsFile = "${self}/secrets/${hostname}/secrets.yaml";

  sops.secrets.tailscale_auth_key = { };
  environment.systemPackages = with pkgs; [ tailscale ];
  services.tailscale = {
    enable = true;
    openFirewall = true;
    authKeyFile = config.sops.secrets.tailscale_auth_key.path;
    useRoutingFeatures = "both";
    extraUpFlags = [
      "--advertise-exit-node"
      "--advertise-routes=${config.networking.custom.lanNetwork}"
    ];
    extraSetFlags = [
      "--advertise-exit-node"
      "--advertise-routes=${config.networking.custom.lanNetwork}"
    ];
  };
}
