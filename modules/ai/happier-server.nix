{ inputs, ... }:
{
  flake.modules.nixos.happier-server =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.nix-happier.nixosModules.happier-server
      ];

      sops.secrets."happier/master_secret" = { };
      sops.templates."happier-server.env".content = ''
        HANDY_MASTER_SECRET=${config.sops.placeholder."happier/master_secret"}
      '';
      services.happier-server = {
        enable = true;
        package = inputs.nix-happier.packages.${pkgs.stdenv.hostPlatform.system}.happier-server;
        mode = "light";
        environmentFile = config.sops.templates."happier-server.env".path;
      };

      services.nginx.virtualHosts."happier.internal.internetfeno.men" = {
        forceSSL = true;
        useACMEHost = "internal.internetfeno.men";
        locations."/" = {
          extraConfig = ''
            proxy_read_timeout 3600;
            proxy_send_timeout 3600;
            proxy_connect_timeout 60;
          '';
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString config.services.happier-server.port}";
        };
      };
    };
}
