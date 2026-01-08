{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  username = "ankarhem";
  hostname = "mbp";

  flake.darwinConfigurations.mbp = inputs.darwin.lib.darwinSystem rec {
    system = "aarch64-darwin";
    specialArgs = {
      inherit
        self
        inputs
        library
        ;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system config;
      };
      username = "ankarhem";
      hostname = "mbp";
    };
    modules = [
      {

        nixpkgs.config = config;
        nixpkgs.overlays = lib.attrValues self.overlays ++ [
          inputs.nur.overlays.default
          (prev: final: {
            scriptPkgs = inputs.scripts.packages.${system};
          })
        ];
      }
      "${self}/hosts/${specialArgs.hostname}/configuration/default.nix"
      inputs.sops-nix.darwinModules.sops
      inputs.nix-homebrew.darwinModules.nix-homebrew
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${specialArgs.username} =
          import "${self}/hosts/${specialArgs.hostname}/home/default.nix";
      }
    ];
  };

  # Custom Library
  libFromDir =
    { directory, callLibraryFn }:
    builtins.listToAttrs (
      builtins.map (name: {
        name = lib.removeSuffix ".nix" name;
        value = callLibraryFn (directory + "/${name}") { };
      }) (builtins.attrNames (builtins.readDir directory))
    );
  library = libFromDir {
    directory = "${self}/lib";
    callLibraryFn = lib.customisation.callPackageWith lib;
  };

  # Nixpkgs configuration
  config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "olm-3.2.16"
    ];
  };
in
{
  inherit flake;
}
