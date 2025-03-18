{config,...}: {
  imports = [
    ./arrs/default.nix
    ./conduwuit.nix
    ./omada.nix
    ./picoshare.nix
    ./swerdle.nix
    ./synology.nix
    ./tibia-api.nix
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
    certs."internal.ankarhem.dev" = {
      domain = "internal.ankarhem.dev";
      extraDomainNames = ["*.internal.ankarhem.dev"];
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
    certs."internal.internetfeno.men" = {
      domain = "internal.internetfeno.men";
      extraDomainNames = ["*.internal.internetfeno.men"];
      email = "admin@internetfeno.men";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.secrets.cloudflare_credentials_env.path;
    };
  };
  users.users.nginx.extraGroups = [ "acme" ];

  networking.networkmanager.insertNameservers = [ "127.0.0.1" ];
  networking.nameservers = ["127.0.0.1"];
  networking.useHostResolvConf = false;
  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4"];
    extraConfig = ''
      DNS=127.0.0.1
    '';
  };
  services.coredns = {
    enable = true;
    config = ''
    . {
      # Cloudflare and Google
      forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
      cache
    }

    internal.internetfeno.men {
      template IN A  {
          answer "{{ .Name }} 0 IN A 192.168.1.221"
      }
    }
    internal.ankarhem.dev {
      template IN A  {
          answer "{{ .Name }} 0 IN A 192.168.1.221"
      }
    }
    '';
  };
  networking.firewall.allowedUDPPorts = [53];

  services.nginx.virtualHosts."ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    root = "/var/www/ankarhem.dev";
  };

  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    dns = [ "192.168.1.221" ];
  };
  virtualisation.oci-containers.backend = "docker";
  virtualisation.podman = {
    enable = false;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
}
