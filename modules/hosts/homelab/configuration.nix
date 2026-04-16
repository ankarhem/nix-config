{
  self,
  inputs,
  ...
}:
{
  flake.modules.nixos.homelab =
    {
      pkgs,
      lib,
      config,
      library,
      modulesPath,
      ...
    }:
    {
      imports = [
        "${modulesPath}/virtualisation/proxmox-lxc.nix"
        ./_tailscale.nix
        ./_fail2ban.nix
        ./_apps/default.nix
        "${self}/nixosModules/networking.nix"
      ]
      ++ (with inputs.self.modules.nixos; [
        ai
        attic
        attic-client
        cli
        colemak
        fish
        fonts
        forgejo
        general
        gh
        gpg
        home-manager
        idealpink
        lazyvim
        nix
        redlib
        secrets
        sshd
      ])
      ++ (with inputs.self.modules.generic; [
        constants
      ]);

      system.autoUpgrade = {
        enable = self ? rev;
        flake = "github:ankarhem/nix-config";
        flags = [
          "--no-update-lock-file"
          "-L"
        ];
        dates = "05:00";
        allowReboot = false;
        operation = "switch";
      };

      boot.isContainer = true;
      proxmoxLXC.manageNetwork = true;

      networking.networkmanager.enable = lib.mkForce false;
      # Custom Networking
      networking.custom.homelabIp = "192.168.1.221";
      networking.custom.synologyIp = "192.168.1.5";
      networking.custom.lanNetwork = "192.168.1.0/24";

      system.stateVersion = "24.05";

      home-manager.sharedModules = [
        inputs.self.modules.generic.constants
        inputs.self.modules.homeManager.homelab
      ];
    };

  flake.modules.homeManager.homelab = {
    home.stateVersion = "24.05";
  };
}
