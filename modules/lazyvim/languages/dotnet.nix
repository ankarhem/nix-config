{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.dotnet = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      csharpier
      omnisharp-roslyn
      (dotnetCorePackages.combinePackages [
        # dotnet-sdk_6
        # dotnet-sdk_7
        dotnet-sdk
        dotnet-sdk_9
        dotnet-sdk_10
      ])
    ];
  };
}
