{
  # Requires the generic `deploy` module (flake.modules.nixos.deploy), which
  # defines the shared `deploy` user this pipeline deploys as.
  flake.modules.nixos.blog =
    { ... }:
    let
      domain = "ankarhem.dev";
      webroot = "/var/lib/blog";
    in
    {
      # CI public key for the blog (ankarhem/site) deploy-rs pipeline, authorized
      # on the shared deploy user.
      users.users.deploy.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlxjwcsF41R6olK820QM3soSHgA1AhnBkqnoLbIZenu blog-deploy-ci@github-actions"
      ];

      # Seed the web root so nginx always has content to serve, even before the
      # first deploy. Both tmpfiles and the deploy activation only ever operate
      # on the `current` symlink, so there is never a dir-vs-symlink conflict.
      systemd.tmpfiles.rules = [
        "d ${webroot} 0755 deploy deploy -"
        "d ${webroot}/placeholder 0755 deploy deploy -"
        "f ${webroot}/placeholder/index.html 0644 deploy deploy - <!DOCTYPE html><title>ankarhem.dev</title><h1>Deploying...</h1>"
        "L ${webroot}/current - - - - ${webroot}/placeholder"
      ];

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        serverAliases = [ "www.${domain}" ];
        root = "${webroot}/current";
        locations."/" = {
          tryFiles = "$uri $uri/ =404";
        };
        extraConfig = ''
          error_page 404 /404.html;
        '';
      };
    };
}
