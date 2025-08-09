{ self, pkgs, username, inputs, ... }: {
  programs.home-manager.enable = true;
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";

  imports = [
    "${self}/presets/fish.nix"
    "${self}/presets/git.nix"
    "${self}/presets/gh.nix"
    "${self}/presets/gpg.nix"
    "${self}/presets/neovim/default.nix"
    ./ssh.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home.file.".config/git/allowed_signers".text =
    "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDP0ZbXrl+MxQ+9l5hcLjNpLs1cfH+8M+K8jT3VEh02w idealpink@homelab";
  programs.git = {
    signing = { key = "~/.ssh/id_ed25519.pub"; };
    extraConfig = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

  programs.nix-index-database = { comma.enable = true; };
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
    sops

    alejandra
  ];

  programs.zoxide = { enable = true; };
  programs.eza.enable = true;
}
