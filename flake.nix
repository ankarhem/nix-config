{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
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
  };

  outputs = inputs @ {self, ...}: {
    nixosConfigurations = let
      inherit (inputs.home-manager.nixosModules) home-manager;
      username = "idealpink";
      hostname = "nixos";
      nixpkgsConfig = {
        config.allowUnfree = true;
      };
    in {
      nixos = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs username hostname;
        };

        modules = [
          ./hosts/homelab/configuration.nix
          home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${username} = import ./hosts/homelab/home.nix;
          }
        ];
      };
    };

    darwinConfigurations = let
      inherit (inputs.darwin.lib) darwinSystem;
      inherit (inputs.nix-homebrew.darwinModules) nix-homebrew;
      inherit (inputs.home-manager.darwinModules) home-manager;

      username = "ankarhem";
      hostname = "ankarhem";

      nixpkgsConfig = {
        config.allowUnfree = true;
      };
    in {
      "${hostname}" = darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs username hostname;
        };
        modules = [
          ./hosts/mbp/default.nix
          nix-homebrew
          home-manager
          {
            nixpkgs = nixpkgsConfig;

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/mbp/home.nix;
          }
        ];
      };
    };
  };
}
