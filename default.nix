inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } [
  # Import all flake-parts modules
  (inputs.import-tree ./modules)
  {
    imports = [
      ./overlays.nix
    ];
  }
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
