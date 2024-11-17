{
  pkgs,
  username,
  inputs,
  ...
}: {
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/gpg/default.nix
    ../../modules/neovim/default.nix
    ./modules/ssh.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index-database = {
    comma.enable = true;
  };
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    openssh

    coreutils
    wget
    curl
    (lib.hiPrio gitAndTools.gitFull)
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

    alejandra
  ];

  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
}
