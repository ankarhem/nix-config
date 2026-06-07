{
  # Generic, reusable deploy user for deploy-rs pipelines. Each project ships its
  # own NixOS module (e.g. the blog's flake.nixosModules.default) which authorizes
  # its CI key on this user and serves its content from /var/lib/deploy/<project>;
  # the project's deploy-rs node pushes to a per-project profile there.
  flake.modules.nixos.deploy =
    { pkgs, ... }:
    {
      users.users.deploy = {
        isSystemUser = true;
        group = "deploy";
        home = "/var/lib/deploy";
        createHome = true;
        # World-traversable so nginx (and other service users) can follow the
        # per-project `current` symlinks under /var/lib/deploy/<project>.
        homeMode = "755";
        shell = pkgs.bashInteractive;
      };
      users.groups.deploy = { };

      # deploy-rs runs `nix copy` to this host, which requires the deploying
      # user to be a trusted Nix user.
      nix.settings.trusted-users = [ "deploy" ];
    };
}
