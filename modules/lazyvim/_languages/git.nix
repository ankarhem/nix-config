{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.git = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      git
    ];
  };
}
