{
  self,
  library,
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
    "${self}/presets/fish.nix"
    "${self}/presets/git.nix"
    "${self}/presets/gh.nix"
    "${self}/presets/gpg.nix"
    "${self}/presets/neovim/default.nix"
    ./ssh.nix
    inputs.nix-index-database.homeModules.nix-index
  ];

  home.file.".config/git/allowed_signers".text =
    let
      authorizedKeys = library.getGithubKeys {
        username = "ankarhem";
        sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
      };
      allowedSigners = builtins.concatStringsSep "\n" (builtins.map (key: "* ${key}") authorizedKeys);
    in
    allowedSigners;
  programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519.pub";
    };
    settings = {
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

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
