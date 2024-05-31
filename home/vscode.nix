_: {
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
}
