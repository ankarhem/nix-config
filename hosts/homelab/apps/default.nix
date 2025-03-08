{...}: {
  imports = [
    # ./plex.nix
    # ./conduwuit.nix
    ./picoshare.nix
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
    allowedTCPPorts = [ 80 443 ];
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "admin@internetfeno.men";

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };
  virtualisation.oci-containers.backend = "docker";
}
