{
  self,
  helpers,
  pkgs,
  username,
  inputs,
  ...
}:
{
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  programs.nix-index-database = {
    comma.enable = true;
  };
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    coreutils
    wget
    curl
    git
    htop
    ripgrep
    rm-improved
    jq
    grc
    gitleaks
    bottom
    bat
    tree
    fd
    nfs-utils
    sops

    alejandra
  ];

  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
}
