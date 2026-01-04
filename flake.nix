{
  description = "MacOS System Configuration flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
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
    homebrew-sikarugir = {
      url = "github:Sikarugir-App/homebrew-sikarugir";
      flake = false;
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks.url = "github:cachix/git-hooks.nix";
    lazyvim.url = "github:pfassina/lazyvim-nix";

    scripts.url = "github:ankarhem/scripts";

    comfyui-nix.url = "github:utensils/comfyui-nix";
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import inputs.nixpkgs { inherit system; };
          pre-commit-hooks = inputs.git-hooks.lib.${system}.run {
            src = ./.;

            hooks = {
              ripsecrets.enable = true;
              nixfmt-rfc-style.enable = true;
            };
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = [ pre-commit-hooks.enabledPackages ];
            shellHook = ''
              ${pre-commit-hooks.shellHook}
            '';
          };
        }
      );

      nixosConfigurations =
        let
          nixpkgsConfig = {
            allowUnfree = true;
            # temporary allow olm-3.2.16 as insecure package
            permittedInsecurePackages = [
              "olm-3.2.16"
            ];
          };
        in
        {
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
          workstation = inputs.nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            specialArgs = {
              pkgs-unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config = nixpkgsConfig;
              };
              inherit inputs;
              inherit self;
              username = "idealpink";
              hostname = "workstation";
              helpers = import ./helpers {
                pkgs = import inputs.nixpkgs { inherit system; };
              };
              scriptPkgs = inputs.scripts.packages.${system};
            };

            modules = [
              ./hosts/${specialArgs.hostname}/configuration/default.nix
              inputs.sops-nix.nixosModules.sops
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.extraSpecialArgs = specialArgs;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.sharedModules = [
                  inputs.plasma-manager.homeModules.plasma-manager
                ];

                home-manager.users.${specialArgs.username} =
                  import ./hosts/${specialArgs.hostname}/home/default.nix;
              }
            ];
          };
        };

      darwinConfigurations =
        let
          nixpkgsConfig = {
            allowUnfree = true;
          };
        in
        {
          mbp = inputs.darwin.lib.darwinSystem rec {
            system = "aarch64-darwin";
            specialArgs = {
              pkgs-unstable = import inputs.nixpkgs-unstable {
                inherit system;
                config = nixpkgsConfig;
              };
              pkgs-darwin = import inputs.nixpkgs-darwin {
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
              scriptPkgs = inputs.scripts.packages.${system};
            };
            modules = [
              ./hosts/${specialArgs.hostname}/configuration/default.nix
              inputs.sops-nix.darwinModules.sops
              inputs.nix-homebrew.darwinModules.nix-homebrew
              inputs.home-manager.darwinModules.home-manager
              {
                nixpkgs = {
                  config = nixpkgsConfig;
                };

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
