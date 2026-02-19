{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.svelte = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      svelte-language-server
    ];
  };
}
