{
  pkgs,
  modulesPath,
  helpers,
  ...
}: {
  imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];

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
      sha256 = "1kjsr54h01453ykm04df55pa3sxj2vrmkwb1p8fzgw5hzfzh3lg0";
    });
  };
}
