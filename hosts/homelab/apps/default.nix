{config,...}: {
  imports = [
    ./plex.nix
    ./tautulli.nix
    ./picoshare.nix
    ./conduwuit.nix
    ./swerdle.nix
    ./tibia-api.nix
    ./kometa.nix
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

  sops.secrets.cloudflare_credentials_env = {
    sopsFile = ../../../secrets/homelab/cloudflare_credentials.env;
    format = "dotenv";
  };
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@internetfeno.men";
    certs."ankarhem.dev" = {
      domain = "ankarhem.dev";
      extraDomainNames = ["*.ankarhem.dev"];
      email = "jakob@ankarhem.dev";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare_credentials_env.path;
    };
    certs."internetfeno.men" = {
      domain = "internetfeno.men";
      extraDomainNames = ["*.internetfeno.men"];
      email = "admin@internetfeno.men";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare_credentials_env.path;
    };
  };
  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx.virtualHosts."ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
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
