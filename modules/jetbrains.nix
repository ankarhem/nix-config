{ inputs, config, ... }:
let
  systemConfigFactory =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        jetbrains.rider
        jetbrains.rust-rover
        jetbrains.webstorm
      ];
    };
in
{
  flake.modules.nixos.jetbrains = systemConfigFactory;

  flake.modules.darwin.jetbrains =
    { pkgs, ... }:
    {
      imports = [
        (systemConfigFactory { inherit pkgs; })
      ];
      system.defaults = {
        dock = {
          persistent-apps = [
            "${pkgs.jetbrains.rider}/Applications/Rider.app/"
            "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
            "${pkgs.jetbrains.webstorm}/Applications/WebStorm.app/"
          ];
        };
      };
    };

  flake.modules.homeManager.jetbrains = { };
}
