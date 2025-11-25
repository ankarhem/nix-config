{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.yaml = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      yamllint
      yq
    ];
  };
}
