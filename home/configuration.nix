{
  pkgs,
  inputs,
  ...
}: {
  home.stateVersion = "23.11";

  imports = [
    ./karabiner.nix
    ./ssh.nix
    ./git.nix
    ./nixvim.nix
    ./gpg.nix
    ./vscode.nix

    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
    # _1password-gui
    # _1password

    # gnupg
    yubikey-personalization
    yubikey-manager
    openssh
    openssl

    coreutils
    wget
    curl
    (lib.hiPrio gitAndTools.gitFull)
    htop
    ripgrep
    jq
    zoxide

    rustup
    alejandra

    mas
    teams
    slack
    spotify
    telegram-desktop
  ];
  programs.eza.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 16;
    };
    theme = "Github";
    shellIntegration = {
      enableFishIntegration = true;
    };
  };

  programs.starship = {
    enable = true;
  };
}
