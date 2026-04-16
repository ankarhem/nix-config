{ inputs, ... }:
let
  repository = "github:ankarhem/nix-config";
in
{
  flake.modules.nixos.auto-upgrade =
    {
      config,
      lib,
      self,
      ...
    }:
    let
      isClean = self ? rev;
    in
    {
      options.services.auto-upgrade = {
        enable = lib.mkEnableOption "automatic daily flake-based NixOS upgrade";
      };

      config = lib.mkIf config.services.auto-upgrade.enable {
        system.autoUpgrade = {
          enable = isClean;
          flake = "${repository}";
          flags = [
            "--no-update-lock-file"
            "-L"
          ];
          dates = "05:00";
          allowReboot = false;
          operation = "switch";
        };
      };
    };
}
