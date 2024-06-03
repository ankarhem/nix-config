{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Neovim
      asvetliakov.vscode-neovim

      # Javascript
      svelte.svelte-vscode
      ## formatting
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint

      # Nx
      # nrwl.angular-console

      # Nix
      jnoortheen.nix-ide
      ## formatting
      kamadorueda.alejandra
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
