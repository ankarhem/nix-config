{
  pkgs,
  username,
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
  ];

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

    alejandra
  ];

  programs.zoxide = {
    enable = true;
  };
  programs.eza.enable = true;
}
