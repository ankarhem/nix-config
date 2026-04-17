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

  flake.modules.darwin.auto-upgrade =
    { pkgs, ... }:
    {
      launchd.daemons.nix-auto-upgrade = {
        enable = self ? rev;
        command = "${pkgs.nix}/bin/nix run nix-darwin -- switch --flake github:ankarhem/nix-config -L --no-update-lock-file";
        serviceConfig = {
          StartCalendarInterval = [{ Hour = 5; Minute = 0; }];
          StandardOutPath = "/var/log/nix-auto-upgrade.log";
          StandardErrorPath = "/var/log/nix-auto-upgrade.log";
        };
      };
    };
}
