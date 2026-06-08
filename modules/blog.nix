{ inputs, ... }:
{
  flake.modules.nixos.blog =
    { pkgs, ... }:
    {
      systemd.tmpfiles.rules = [
        "d /var/www 0755 root root - -"
        "L /var/www/ankarhem.dev - - - - ${inputs.blog.packages.${pkgs.hostPlatform.system}.blog}/public"
      ];

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
