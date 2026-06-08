{
  flake.modules.nixos.deploy = {
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMlxjwcsF41R6olK820QM3soSHgA1AhnBkqnoLbIZenu deploy-ci@github-actions"
    ];
  };
}
