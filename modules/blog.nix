{ inputs, ... }:
{
  flake.modules.nixos.blog =
    { pkgs, ... }:
    {
      systemd.services.link-blog-wwwroot = {
        after = [ "local-fs.target" ];
        before = [ "nginx.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          # Seed the directory if it doesn't exist
          if [ ! -f /var/lib/ankarhem.dev/ ]; then
              mkdir -p /var/lib/ankarhem.dev/
              ln -sfn "${inputs.blog.packages.${pkgs.hostPlatform.system}.blog}/public" /var/www/ankarhem.dev
          fi
        '';
      };

      services.nginx.virtualHosts."ankarhem.dev" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        root = "/var/www/ankarhem.dev";
      };
    };
}
