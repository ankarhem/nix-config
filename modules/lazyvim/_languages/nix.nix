{ pkgs, ... }:
{
  programs.lazyvim = {
    extras = {
      lang.nix = {
        enable = true;
        installDependencies = true;
        installRuntimeDependencies = true;
      };
    };

    extraPackages = with pkgs; [
      nixd
      statix
      nixpkgs-fmt
      alejandra
    ];
  };
}
