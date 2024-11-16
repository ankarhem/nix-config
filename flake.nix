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

  outputs = inputs @ {self, ...}: let
    nixpkgsConfig = {
      config.allowUnfree = true;
    };
  in {
    darwinConfigurations = let
      inherit (inputs.darwin.lib) darwinSystem;
      inherit (inputs.nix-homebrew.darwinModules) nix-homebrew;
      inherit (inputs.home-manager.darwinModules) home-manager;

      username = "ankarhem";
      hostname = "ankarhem";
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
          ./hosts/darwin/default.nix
          nix-homebrew
          home-manager
          {
            nixpkgs = nixpkgsConfig;

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = import ./hosts/darwin/home.nix;
          }
        ];
      };
    };
  };
}
