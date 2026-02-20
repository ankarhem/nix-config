{ inputs, ... }:
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
      homebrew.casks = [
        "cursor"
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
    let
      combinedDotnet = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnet-sdk_8
        pkgs.dotnet-sdk_9
        pkgs.dotnet-sdk_10
      ];
    in
    {
      programs.zed-editor.enable = true;
      programs.go.enable = true;

      home.file.".nuget/plugins".source = pkgs.symlinkJoin {
        name = "dotnet-plugins";
        paths = [
          "${pkgs.local.artifacts-credprovider}/plugins"
        ];
      };

      home.packages =
        with pkgs;
        [
          azure-cli
          pkgs.local.clone_org
          mitmproxy
          bruno
          jira-cli-go
          jetbrains.rider
          jetbrains.rust-rover
          jetbrains.webstorm
        ]
        ++ [ combinedDotnet ];
    };
}
