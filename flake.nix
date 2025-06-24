{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = { url = "github:zhaofengli-wip/nix-homebrew"; };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, ... }: {
    nixosConfigurations = let nixpkgsConfig = { allowUnfree = true; };
    in {
      installer = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit self;
          helpers = import ./helpers {
            pkgs = import inputs.nixpkgs { inherit system; };
          };
        };
        modules = [ ./hosts/installer/configuration.nix ];
      };
      homelab = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs;
          inherit self;
          username = "idealpink";
          hostname = "homelab";
          helpers = import ./helpers {
            pkgs = import inputs.nixpkgs { inherit system; };
          };
        };

        modules = [
          ./hosts/${specialArgs.hostname}/configuration/default.nix
          inputs.sops-nix.nixosModules.sops
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${specialArgs.username} =
              import ./hosts/${specialArgs.hostname}/home/default.nix;
          }
        ];
      };
    };

    darwinConfigurations = let nixpkgsConfig = { allowUnfree = true; };
    in {
      mbp = inputs.darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs;
          inherit self;
          username = "ankarhem";
          hostname = "mbp";
          helpers = import ./helpers {
            pkgs = import inputs.nixpkgs { inherit system; };
          };
        };
        modules = [
          ./hosts/${specialArgs.hostname}/configuration/default.nix
          inputs.sops-nix.darwinModules.sops
          inputs.nix-homebrew.darwinModules.nix-homebrew
          inputs.home-manager.darwinModules.home-manager
          {
            nixpkgs = { config = nixpkgsConfig; };

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${specialArgs.username} =
              import ./hosts/${specialArgs.hostname}/home/default.nix;
          }
        ];
      };
    };
  };
}
