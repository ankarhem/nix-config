{ inputs, config, ... }:
let
  domain = "knot.ankarhem.dev";
  internalPort = "5444";
  publicPort = "5555";
in
{
  imports = [
    inputs.tangled.nixosModules.knot
  ];

  services.tangled.knot = {
    enable = true;
    package = inputs.tangled.packages.${config.nixpkgs.hostPlatform.system}.knot;
    stateDir = "/var/lib/tangled-knot";
    repo.scanPath = "/mnt/DISKETTEN_drive/tangled/repos";
    server = {
      listenAddr = "127.0.0.1:${publicPort}";
      internalListenAddr = "127.0.0.1:${internalPort}";
      hostname = domain;
      owner = "did:plc:freiumm55hanqgziwfajvhn6";
    };
    openFirewall = false;
  };

  services.nginx.virtualHosts."${domain}" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${publicPort}";
      proxyWebsockets = true;
    };
  };
}
