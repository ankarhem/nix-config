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
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
}
