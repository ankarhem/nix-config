{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.toml = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };
  };
}
