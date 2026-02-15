{ inputs, ... }:
{
  flake.modules.nixos.workstation = {
    imports =
      with inputs.self.modules.nixos;
      [
        ai
        ankarhem
        audio
        bluetooth
        chat
        cli
        colemak
        comfyui
        dev-tools
        firefox
        fish
        fonts
        gaming
        general
        gh
        gpg
        gpu-nvidia
        home-manager
        kde
        launcher
        lazyvim
        nix
        norcevpn
        secrets
        sshd
      ]
      ++ (with inputs.self.modules.generic; [
        constants
      ]);

    home-manager.sharedModules = [
      inputs.self.modules.generic.constants
      inputs.self.modules.homeManager.workstation
    ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    hardware.enableAllFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;

    system.stateVersion = "25.11";
  };

  flake.modules.homeManager.workstation = {
    home.stateVersion = "25.11";
  };
}
