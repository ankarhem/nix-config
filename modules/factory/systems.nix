{
  inputs,
  lib,
  ...
}:
{
  config.flake.factory = {
    nixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            networking.hostName = name;
          }
        ];
      };
    };
    darwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          {
            nixpkgs.hostPlatform = lib.mkDefault system;
            networking.hostName = name;
            networking.computerName = name;
          }
        ];
      };
    };
    homeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager.${name}
          { nixpkgs.config.allowUnfree = true; }
        ];
      };
    };
  };
}
