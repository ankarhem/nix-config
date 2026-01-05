# Workstation host - NixOS workstation with KDE
{
  inputs,
  lib,
  config,
  ...
}:
let
  username = "idealpink";
  hostname = "workstation";
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "olm-3.2.16" ];
    };
  };
  helpers = config.helpers;
  scriptPkgs = inputs.scripts.packages.x86_64-linux or { };
in
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit helpers username hostname;
      self = inputs.self;
      inherit inputs;
      inherit pkgs-unstable scriptPkgs;
    };
    modules = [
      # Host-specific configuration
      "${inputs.self}/hosts/${hostname}/configuration/default.nix"

      # Dendritic aspects from modules.nixos.*
      inputs.self.modules.nixos.docker

      # External modules
      inputs.sops-nix.nixosModules.sops

      # Home Manager integration
      inputs.home-manager.nixosModules.home-manager
      {
        # Set hostname
        networking.hostName = hostname;
      }
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
            scriptPkgs
            helpers
            inputs
            username
            ;
          self = inputs.self;
        };
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
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
    ];
  };
}
