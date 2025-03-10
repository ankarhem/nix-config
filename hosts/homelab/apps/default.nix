{...}: {
  imports = [
    ./plex.nix
    ./tautulli.nix
    ./picoshare.nix
    ./conduwuit.nix
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@internetfeno.men";

  services.nginx.virtualHosts."ankarhem.dev" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/ankarhem.dev";
  };

  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53];
}
