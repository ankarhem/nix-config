# MBP host - Darwin (macOS) laptop
{
  inputs,
  lib,
  config,
  ...
}:
let
  username = "ankarhem";
  hostname = "mbp";
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "aarch64-darwin";
    config.allowUnfree = true;
  };
  pkgs-darwin = import inputs.nixpkgs-darwin {
    system = "aarch64-darwin";
    config.allowUnfree = true;
  };
  helpers = config.helpers;
  scriptPkgs = inputs.scripts.packages.aarch64-darwin or { };
in
{
  flake.darwinConfigurations.mbp = inputs.darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit helpers username hostname;
      self = inputs.self;
      inherit inputs;
      inherit pkgs-unstable pkgs-darwin scriptPkgs;
    };
    modules = [
      # Host-specific configuration
      "${inputs.self}/hosts/${hostname}/configuration/default.nix"

      # Dendritic aspects from modules.darwin.*
      inputs.self.modules.darwin.settings

      # External modules
      inputs.sops-nix.darwinModules.sops
      inputs.nix-homebrew.darwinModules.nix-homebrew

      # Set hostname
      {
        networking.hostName = hostname;
      }

      # Home Manager integration
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            inputs.nur.overlays.default
          ];
        };

        home-manager.extraSpecialArgs = {
          inherit
            pkgs-unstable
            pkgs-darwin
            scriptPkgs
            helpers
            inputs
            username
            ;
          self = inputs.self;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${username} = {
          imports = [
            # Dendritic aspects from modules.homeManager.*
            inputs.self.modules.homeManager.scripts
            inputs.self.modules.homeManager.fish
            inputs.self.modules.homeManager.git
            inputs.self.modules.homeManager.gh
            inputs.self.modules.homeManager.gpg
            inputs.self.modules.homeManager.neovim
            inputs.self.modules.homeManager.firefox
            inputs.self.modules.homeManager.vscode
            inputs.self.modules.homeManager.dotnet

            # Host-specific home configuration
            "${inputs.self}/hosts/${hostname}/home/default.nix"
          ];

          # Git SSH signing configuration
          home.file.".config/git/allowed_signers".text =
            let
              authorizedKeys = helpers.ssh.getGithubKeys {
                username = "ankarhem";
                sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
              };
              allowedSigners = lib.concatStringsSep "\n" (map (key: "* ${key}") authorizedKeys);
            in
            allowedSigners;
          programs.git = {
            signing.key = "~/.ssh/id_ed25519.pub";
            settings.gpg.format = "ssh";
            settings.gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
          };

          # Dotnet and custom scripts
          programs.dotnet = {
            enable = true;
            enableAzureArtifactsCredProvider = true;
          };
          modules.custom-scripts.enable = true;

          # nix-index
          programs.nix-index-database.comma.enable = true;
          programs.nix-index.enable = true;

          # Other programs
          programs.zoxide.enable = true;
          programs.eza.enable = true;
          programs.starship.enable = true;
          programs.go = {
            enable = true;
            env.GOPATH = ".go";
          };
        };
      }

      # Darwin settings aspect
      {
        darwin.settings.enable = true;
      }
    ];
  };
}
