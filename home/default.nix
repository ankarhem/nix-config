{
  pkgs,
  inputs,
  ...
}: {
  home.username = "ankarhem";
  home.homeDirectory = "/Users/ankarhem";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  imports = [
    ./karabiner.nix
    ./ssh.nix
    ./git.nix
    ./nixvim/default.nix
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

    rustup
    alejandra
    devenv

    mas
    teams
    slack
    spotify
    telegram-desktop
    rectangle
  ];
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    # Reorders stuff so that nix can override system binaries
    loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
  };

  programs.zoxide = {
    enable = true;
  };
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
