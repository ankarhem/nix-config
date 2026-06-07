{
  # Generic, reusable deploy user for deploy-rs pipelines. Project modules
  # (e.g. blog.nix) add their own CI public key via
  #   users.users.deploy.openssh.authorizedKeys.keys = [ ... ];
  # and create per-project deploy-rs profiles under this single user
  # (profile path: /nix/var/nix/profiles/per-user/deploy/<project>).
  flake.modules.nixos.deploy =
    { pkgs, ... }:
    {
      users.users.deploy = {
        isSystemUser = true;
        group = "deploy";
        home = "/var/lib/deploy";
        createHome = true;
        shell = pkgs.bashInteractive;
      };
      users.groups.deploy = { };

      # deploy-rs runs `nix copy` to this host, which requires the deploying
      # user to be a trusted Nix user.
      nix.settings.trusted-users = [ "deploy" ];
    };
}
