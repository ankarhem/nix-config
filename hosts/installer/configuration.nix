{
  pkgs,
  modulesPath,
  helpers,
  ...
}:
{
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];

  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    neovim
    git
    gptfdisk
  ];

  services.openssh = {
    enable = true;
  };

  users.users.nixos = {
    openssh.authorizedKeys.keys = helpers.ssh.getGithubKeys ({
      username = "ankarhem";
      sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
    });
  };
}
