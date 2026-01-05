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

  # Devshells
  {
    perSystem =
      { pkgs }:
      let
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
      };
  }
]
