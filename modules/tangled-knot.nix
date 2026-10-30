{ inputs, ... }: {
  flake.modules.nixos.tangled-knot =
    { config, ... }:
    let
      domain = "knot.ankarhem.dev";
      publicPort = "5555";
    in
    {
      imports = [
        inputs.tangled.nixosModules.knot-rs
      ];

      sops.secrets."knot/master_key" = { };
      sops.templates."knot.env".content = ''
        KNOT_MASTER_KEY=${config.sops.placeholder."knot/master_key"}
      '';

      services.tangled.knot-rs = {
        enable = true;
        environmentFile = config.sops.templates."knot.env".path;
        settings = {
          server = {
            hostname = domain;
            admins = [ "did:plc:freiumm55hanqgziwfajvhn6" ];
            listen_addr = "127.0.0.1:${publicPort}";
            # Public 22 is forwarded to the admin sshd; the router forwards 2222 here.
            ssh_listen_addr = "[::]:2222";
          };
          git.object_format = "sha1";
          lfs.store_path = "/var/lib/knot/lfs";
          contact.email = "admin@ankarhem.dev";
          atproto.plc_directory = "https://plc.directory";
          # pds.ankarhem.dev resolves to the LAN address here, and the knot's
          # outbound guard refuses private addresses, so it can't read SSH keys.
          http.block_private_addresses = false;
          xrpc = {
            trusted_proxy_header = "x-forwarded-for";
            trusted_proxies = [
              "127.0.0.1"
              "::1"
            ];
          };
        };
      };
      systemd.services.knot-rs.serviceConfig = {
        MemoryMax = "4G";
        MemorySwapMax = "0";
      };

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${publicPort}";
        };
        locations."/events" = {
          proxyPass = "http://127.0.0.1:${publicPort}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_read_timeout 86400s;
          '';
        };
      };

      services.fail2ban.jails.sshd.settings = {
        enabled = true;
        maxretry = 3;
      };
    };
}
