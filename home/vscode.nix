{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      jnoortheen.nix-ide
      kamadorueda.alejandra

      # Javascript
      svelte.svelte-vscode
    ];
    userSettings = {
      # Neovim integration
      "extensions.experimental.affinity" = {
        "asvetliakov.vscode-neovim" = 1;
      };

      # Font settings
      "editor.fontSize" = 14;
      "editor.fontFamily" = "Iosevka Nerd Font";
      "terminal.integrated.fontSize" = 14;

      "workbench.colorTheme" = "Default Light Modern";

      # Nix settings
      "[nix]" = {
        "editor.defaultFormatter" = "kamadorueda.alejandra";
        "editor.formatOnPaste" = true;
        "editor.formatOnSave" = true;
        "editor.formatOnType" = false;
      };
      "alejandra.program" = "alejandra";
    };
  };
}
