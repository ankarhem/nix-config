{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      ms-vsliveshare.vsliveshare
      github.copilot

      asvetliakov.vscode-neovim
      catppuccin.catppuccin-vsc
      catppuccin.catppuccin-vsc-icons
      svelte.svelte-vscode
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ng-template";
          publisher = "angular";
          version = "18.2.0";
          sha256 = "sha256-rl04nqSSBMjZfPW8Y+UtFLFLDFd5FSxJs3S937mhDWE=";
        };
      })
      vue.volar
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "arkdark";
          publisher = "arktypeio";
          version = "5.12.2";
          sha256 = "sha256-rnYX+8KFx9WBOhI7OFIuBX0cyG3hJbJh/c5vxcTXMvw=";
        };
      })
      bradlc.vscode-tailwindcss
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-angular-html";
          publisher = "ghaschel";
          version = "2.13.0";
          sha256 = "sha256-z+NnZpqa7jxUhtwPMi5D7UT9H1xnlwZgPJeE88/Kfww=";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "playwright";
          publisher = "ms-playwright";
          version = "1.1.10";
          sha256 = "sha256-ALsbUWJERbP+p4uhRnDq6ovwinczZVZbbqd9eXumEng=";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "explorer";
          publisher = "vitest";
          version = "0.12.0";
          sha256 = "sha256-lIpYU3w8M7sXL0JSKReXfnbRCFzs2ggwqfwi6E5M9cg=";
        };
      })
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
      kamadorueda.alejandra

      rust-lang.rust-analyzer
      fill-labs.dependi
      tamasfe.even-better-toml

      golang.go
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "templ";
          publisher = "a-h";
          version = "0.0.26";
          sha256 = "sha256-/77IO+WjgWahUrj6xVl0tkvICh9Cy+MtfH2dewxH8LE=";
        };
      })
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "htmx-tags";
          publisher = "otovo-oss";
          version = "0.0.8";
          sha256 = "sha256-sF5VpdmPluygAiGt9a9E/bM/VzA6a++0dR87dweMCyQ=";
        };
      })

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "angular-console";
          publisher = "nrwl";
          version = "18.21.4";
          sha256 = "sha256-TbTe5KjtmQ3pA/3nmuUiQdZBl+MIZVa+Q6YguYBPYdk=";
        };
      })

      jnoortheen.nix-ide

      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bruno";
          publisher = "bruno-api-client";
          version = "3.1.0";
          sha256 = "sha256-jLQincxitnVCCeeaoX0SOuj5PJyR7CdOjK4Kl52ShlA=";
        };
      })
    ];

    keybindings = [
      {
        key = "Cmd+Shift+I";
        command = "editor.action.sourceAction";
        # when = "config.workspaceKeybindings.importMissingDeps.enabled";
        args = {
          kind = "source.addMissingImports";
          apply = "first";
        };
      }
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

      "workbench.colorTheme" = "Catppuccin Latte";
      "workbench.iconTheme" = "catppuccin-latte";

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
