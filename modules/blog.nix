{
  flake.modules.nixos.blog =
    { pkgs, ... }:
    let
      domain = "ankarhem.dev";
      webroot = "/var/lib/blog";
    in
    {
      # Unprivileged user that the blog's GitHub Actions pipeline deploys as via
      # deploy-rs. sshUser == user on the deploy node, so no sudo is required:
      # the user owns its Nix profile and the web root below.
      users.users.blog-deploy = {
        isSystemUser = true;
        group = "blog-deploy";
        home = webroot;
        createHome = true;
        shell = pkgs.bashInteractive;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlxjwcsF41R6olK820QM3soSHgA1AhnBkqnoLbIZenu blog-deploy-ci@github-actions"
        ];
      };
      users.groups.blog-deploy = { };

      # deploy-rs runs `nix copy` to this host, which requires the deploying user
      # to be a trusted Nix user.
      nix.settings.trusted-users = [ "blog-deploy" ];

      # Seed the web root so nginx always has content to serve, even before the
      # first deploy. Both tmpfiles and the deploy activation only ever operate
      # on the `current` symlink, so there is never a dir-vs-symlink conflict.
      systemd.tmpfiles.rules = [
        "d ${webroot} 0755 blog-deploy blog-deploy -"
        "d ${webroot}/placeholder 0755 blog-deploy blog-deploy -"
        "f ${webroot}/placeholder/index.html 0644 blog-deploy blog-deploy - <!DOCTYPE html><title>ankarhem.dev</title><h1>Deploying...</h1>"
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
