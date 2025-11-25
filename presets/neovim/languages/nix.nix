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
      nixpkgs-fmt
      alejandra
    ];
  };
}
