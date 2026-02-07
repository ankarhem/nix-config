{ inputs, config, ... }:
{
  flake.modules.nixos.dev-tools = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.ide
    ];
  };
  flake.modules.darwin.dev-tools =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.ide
      ];
      system.defaults.dock.persistent-apps = [
        "${pkgs.bruno}/Applications/Bruno.app/"
        "${pkgs.jetbrains.rider}/Applications/Rider.app/"
        "${pkgs.jetbrains.rust-rover}/Applications/RustRover.app/"
        "${pkgs.jetbrains.webstorm}/Applications/WebStorm.app/"
      ];
    };

  flake.modules.homeManager.dev-tools =
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
