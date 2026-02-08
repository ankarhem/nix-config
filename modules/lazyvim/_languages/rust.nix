{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.rust = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      bacon
      cargo
      clippy
      rust-analyzer
      rustfmt
      rustup
    ];
  };
}
