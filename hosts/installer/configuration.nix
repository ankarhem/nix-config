{
  pkgs,
  modulesPath,
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINyP+c89r1blDaX3MI8kxqFlRsUquGmI9qWMOyo9n5oV ankarhem@ankarhem"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIFnDqR5H4mLaZ97/fKkNqNn6SfRk2HcTvQkdDGt39DcCAAAAC3NzaDpTU0ggS2V5 ankarhem@ankarhem"
    ];
  };
}
