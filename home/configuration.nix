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

    mas
    teams
    slack
    spotify
    telegram-desktop
  ];
  programs.eza.enable = true;

  programs.gpg = {
    enable = true;

    publicKeys = [
      {
        source = ./yubikey.pub;
        trust = 5;
      }
    ];

    # https://raw.githubusercontent.com/drduh/config/master/gpg.conf
    settings = {
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      cert-digest-algo = "SHA512";
      s2k-digest-algo = "SHA512";
      s2k-cipher-algo = "AES256";
      charset = "utf-8";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      with-fingerprint = true;
      require-cross-certification = true;
      no-symkey-cache = true;
      armor = true;
      use-agent = true;
      throw-keyids = true;
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      jnoortheen.nix-ide
      kamadorueda.alejandra
    ];
    userSettings = {
      # Neovim integration
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      # Nix settings
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "alejandra.program" = "alejandra";

      # Font settings
      "editor.fontSize" = 14;
      "editor.fontFamily" = "Iosevka Nerd Font";
      "terminal.integrated.fontSize" = 14;
    };
  };

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
