{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.docker = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      hadolint
    ];
  };
}
