{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.json = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      jq
    ];
  };
}
