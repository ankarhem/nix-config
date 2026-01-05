inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } [
  # Import all flake-parts modules
  (inputs.import-tree ./modules)

  # Setup packages
  (
    { withSystem, config, ... }:
    {
      # Expose publically
      # flake.overlays.default = final: prev: {
      #   local = withSystem prev.stdenv.hostPlatform.system ({config}:config.packages);
      # };
      perSystem =
        {
          system,
          config,
          lib,
          pkgs,
          ...
        }:
        {
          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./packages;
          };
          # Add the 'local' package-set to pkgs
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              (final: prev: {
                local = config.packages;
              })
            ];
          };
        };
    }
  )
]
