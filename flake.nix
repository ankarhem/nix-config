{
  description = "Ankarhem configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, darwin, home-manager, nixpkgs }: {
    
    darwinConfigurations.ankarhem = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/ankarhem/default.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
