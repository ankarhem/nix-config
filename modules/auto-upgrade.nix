{ self, ... }:
{
  flake.modules.nixos.auto-upgrade = {
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
  };
}
