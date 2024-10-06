{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      github.copilot

      # Neovim
      asvetliakov.vscode-neovim

      # Javascript
      svelte.svelte-vscode
      angular.ng-template
      vue.volar
      ## Angular
      bradlc.vscode-tailwindcss
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "vscode-angular-html";
          publisher = "ghaschel";
          version = "2.13.0";
          sha256 = "sha256-z+NnZpqa7jxUhtwPMi5D7UT9H1xnlwZgPJeE88/Kfww=";
        };
      })
      # testing
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "playwright";
          publisher = "ms-playwright";
          version = "1.1.10";
          sha256 = "sha256-ALsbUWJERbP+p4uhRnDq6ovwinczZVZbbqd9eXumEng=";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "explorer";
          publisher = "vitest";
          version = "0.12.0";
          sha256 = "sha256-lIpYU3w8M7sXL0JSKReXfnbRCFzs2ggwqfwi6E5M9cg=";
        };
      })
      ## formatting
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      kamadorueda.alejandra

      # Rust
      rust-lang.rust-analyzer
      fill-labs.dependi
      tamasfe.even-better-toml

      # Go
      golang.go
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "templ";
          publisher = "a-h";
          version = "0.0.26";
          sha256 = "sha256-/77IO+WjgWahUrj6xVl0tkvICh9Cy+MtfH2dewxH8LE=";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "htmx-tags";
          publisher = "otovo-oss";
          version = "0.0.8";
          sha256 = "sha256-sF5VpdmPluygAiGt9a9E/bM/VzA6a++0dR87dweMCyQ=";
        };
      })

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
