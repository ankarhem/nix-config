- Use mcp-nixos when searching for nix packages or options
- You can run `nix flake check` to check whether the flake evaluates and run its tests
- Use `gh` cli to interact with GitHub from the command line. For example, `gh pr create` to create a pull request.
- NEVER modify `secrets.yaml` — it is encrypted with sops and cannot be edited directly. Assume secrets exist and tell the user what secrets need to be created instead.

