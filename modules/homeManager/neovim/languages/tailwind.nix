{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.tailwind = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      tailwindcss
    ];
  };
}
