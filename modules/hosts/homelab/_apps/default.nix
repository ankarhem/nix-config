{
  self,
  config,
  lib,
  ...
}:
{
  imports = [
    "${self}/nixosModules/docker.nix"
    ./arrs/default.nix
    ./baikal.nix
    ./dokploy.nix
    ./hitster.nix
    ./immich.nix
    ./internal-vhosts.nix
    ./obsidian-livesync.nix
    ./omada.nix
    # ./open-webui.nix
    ./opencode-server/default.nix
    ./picoshare.nix
    ./seafile.nix
    ./swerdle.nix
    ./synology.nix
    ./telemetry/default.nix
    ./tuwunel.nix
    ./vaultwarden/default.nix
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
    allowedTCPPorts = [
      53
      80
      443
    ];
  };

  sops.secrets."cloudflare/dns_token" = { };
  sops.templates."cloudflare.env".content = ''
    CF_DNS_API_TOKEN=${config.sops.placeholder."cloudflare/dns_token"}
  '';
  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@internetfeno.men";
    certs."ankarhem.dev" = {
      domain = "ankarhem.dev";
      extraDomainNames = [ "*.ankarhem.dev" ];
      email = "jakob@ankarhem.dev";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."cloudflare.env".path;
    };
    certs."internal.ankarhem.dev" = {
      domain = "internal.ankarhem.dev";
      extraDomainNames = [ "*.internal.ankarhem.dev" ];
      email = "jakob@ankarhem.dev";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."cloudflare.env".path;
    };
    certs."internetfeno.men" = {
      domain = "internetfeno.men";
      extraDomainNames = [ "*.internetfeno.men" ];
      email = "admin@internetfeno.men";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."cloudflare.env".path;
    };
    certs."internal.internetfeno.men" = {
      domain = "internal.internetfeno.men";
      extraDomainNames = [ "*.internal.internetfeno.men" ];
      email = "admin@internetfeno.men";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."cloudflare.env".path;
    };
    certs."hub.internetfeno.men" = {
      domain = "hub.internetfeno.men";
      extraDomainNames = [ "*.hub.internetfeno.men" ];
      email = "admin@internetfeno.men";
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.sops.templates."cloudflare.env".path;
    };
  };
  users.users.nginx.extraGroups = [ "acme" ];

  networking.nameservers = [
    "127.0.0.1"
    "1.1.1.1"
    "1.0.0.1"
    "8.8.8.8"
    "8.8.4.4"
  ];
  networking.useHostResolvConf = false;
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = [ "127.0.0.1" ];
      DNSStubListener = "no";
      FallbackDNS = [
        "1.1.1.1"
        "1.0.0.1"
        "8.8.8.8"
        "8.8.4.4"
      ];
    };
  };
  services.coredns = {
    enable = true;
    config = ''
      . {
        # The router has no NAT loopback, so names served by this nginx
        # resolve to the LAN IP; everything else goes upstream.
        hosts {
          ${config.networking.custom.homelabIp} ${
            lib.concatStringsSep " " (
              builtins.filter (n: !lib.hasInfix "*" n) (builtins.attrNames config.services.nginx.virtualHosts)
            )
          }
          fallthrough
        }
        # Cloudflare and Google
        forward . 1.1.1.1 1.0.0.1 8.8.8.8 8.8.4.4
        cache
      }

      internal.internetfeno.men internal.ankarhem.dev {
        template IN A  {
            answer "{{ .Name }} 0 IN A ${config.networking.custom.homelabIp}"
        }
        # Everything else empty: Cloudflare's AAAA and HTTPS (ECH) records
        # would send clients to Cloudflare instead of the LAN A.
        template ANY ANY {
            rcode NOERROR
        }
      }
    '';
  };
  networking.firewall.allowedUDPPorts = [ 53 ];

  virtualisation.containers.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    dns = [ config.networking.custom.homelabIp ];
  };
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.autoUpdater.enable = true;
  virtualisation.podman = {
    enable = false;
    autoPrune.enable = true;
    dockerCompat = true;
    defaultNetwork.settings = {
      dns_enabled = true;
    };
  };
}
