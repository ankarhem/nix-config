{
  flake.modules.homeManager.dotnet =
    { pkgs }:
    let
      combinedDotnet = pkgs.dotnetCorePackages.combinePackages [
        pkgs.dotnet-sdk_8
        pkgs.dotnet-sdk_9
        pkgs.dotnet-sdk_10
      ];
    in
    {
      home.packages = [ combinedDotnet ];

      home.file.".nuget/plugins".source = pkgs.symlinkJoin {
        name = "dotnet-plugins";
        paths = [
          pkgs.local.dotnetPlugins.artifacts-credprovider
        ];
      };
    };
}
