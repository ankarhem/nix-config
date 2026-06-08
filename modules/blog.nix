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
          # Cold-start seed: only link the blog build if nothing is serving yet.
          # Once deploy-rs (or a previous seed) has pointed this at a valid
          # directory, the guard is true and we leave the deployed build alone.
          if [ ! -d /var/www/ankarhem.dev ]; then
              mkdir -p /var/www
              ln -sfn "${inputs.blog.packages.${pkgs.hostPlatform.system}.blog}/public" /var/www/ankarhem.dev
          fi
        '';
      };

      services.nginx.virtualHosts."ankarhem.dev" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        root = "/var/www/ankarhem.dev";
        locations."/".tryFiles = "$uri $uri/ =404";
        locations."= /404.html".extraConfig = "internal;";
        extraConfig = ''
          error_page 404 /404.html;
        '';
      };
    };
}
