{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, ...}: {
    nixosConfigurations = let
      nixpkgsConfig = {
        config.allowUnfree = true;
      };
    in {
      installer = inputs.nixpkgs.lib.nixosSystem rec {
        # system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/installer/configuration.nix
        ];
      };
      homelab = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs;
          username = "idealpink";
          hostname = "homelab";
        };

        modules = [
          ./hosts/homelab/configuration.nix
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${specialArgs.username} = import ./hosts/${specialArgs.hostname}/home.nix;
          }
        ];
      };
      # nas = inputs.nixpkgs.lib.nixosSystem rec {
      #   system = "x86_64-linux";
      #   specialArgs = {
      #     pkgs-unstable = import inputs.nixpkgs-unstable {
      #       inherit system;
      #       config = nixpkgsConfig;
      #     };
      #     inherit inputs;
      #     username = "idealpink";
      #     hostname = "nas";
      #   };

      #   modules = [
      #     ./hosts/nas/configuration.nix
      #     inputs.home-manager.nixosModules.home-manager
      #     {
      #       home-manager.extraSpecialArgs = specialArgs;
      #       home-manager.useGlobalPkgs = true;
      #       home-manager.useUserPackages = true;

      #       home-manager.users.${specialArgs.username} = import ./hosts/${specialArgs.hostname}/home.nix;
      #     }
      #   ];
      # };
      wsl = inputs.nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs;
          username = "nixos";
          hostname = "wsl";
        };

        modules = [
          ./hosts/wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${specialArgs.username} = import ./hosts/${specialArgs.hostname}/home.nix;
          }
        ];
      };
    };

    darwinConfigurations = let
      nixpkgsConfig = {
        config.allowUnfree = true;
      };
    in {
      mbp = inputs.darwin.lib.darwinSystem rec {
        system = "aarch64-darwin";
        specialArgs = {
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config = nixpkgsConfig;
          };
          inherit inputs;
          username = "ankarhem";
          hostname = "mbp";
        };
        modules = [
          ./hosts/mbp/default.nix
          inputs.nix-homebrew.darwinModules.nix-homebrew
          inputs.home-manager.darwinModules.home-manager
          {
            nixpkgs = nixpkgsConfig;

            home-manager.extraSpecialArgs = specialArgs;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${specialArgs.username} = import ./hosts/${specialArgs.hostname}/home.nix;
          }
        ];
      };
    };
  };
}
