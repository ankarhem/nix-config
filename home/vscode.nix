{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      # Neovim
      asvetliakov.vscode-neovim

      # Javascript
      svelte.svelte-vscode
      bradlc.vscode-tailwindcss
      ## formatting
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint

      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml

      # Nx
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "angular-console";
          publisher = "nrwl";
          version = "18.21.4";
          sha256 = "sha256-TbTe5KjtmQ3pA/3nmuUiQdZBl+MIZVa+Q6YguYBPYdk=";
        };
      })

      # Nix
      jnoortheen.nix-ide
      ## formatting
      kamadorueda.alejandra

      # Syntax highlighting for .bru
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "bruno";
          publisher = "bruno-api-client";
          version = "3.1.0";
          sha256 = "sha256-jLQincxitnVCCeeaoX0SOuj5PJyR7CdOjK4Kl52ShlA=";
        };
      })
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
