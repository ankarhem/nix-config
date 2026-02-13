{ inputs, config, ... }:
{
  flake.modules.nixos.dev-tools = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.dev-tools
    ];
  };
  flake.modules.darwin.dev-tools =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.dev-tools
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
      programs.go.enable = true;
      home.packages = with pkgs; [
        azure-cli
        mitmproxy
        bruno
        jetbrains.rider
        jetbrains.rust-rover
        jetbrains.webstorm
      ];
    };
}
