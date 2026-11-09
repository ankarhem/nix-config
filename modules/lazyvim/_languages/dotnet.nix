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
        dotnetCorePackages.sdk_9_0-bin
        dotnetCorePackages.sdk_10_0-bin
        dotnetCorePackages.sdk_11_0-bin
      ])
    ];
  };
}
