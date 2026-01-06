{ inputs, config, ... }:
{
  flake.modules.darwin.dev =
    { pkgs, ... }:
    {
      system.defaults.dock.persistent-apps = [
        "${pkgs.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
        "${pkgs.jetbrains.webstorm}/Applications/WebStorm.app/"
      ];
    };

  flake.modules.homeManager.dev =
    { pkgs, ... }:
    {
      programs.zed-editor.enable = true;
      home.packages = with pkgs; [
        bruno
        jetbrains.rider
        jetbrains.rust-rover
        jetbrains.webstorm
      ];
    };
}
