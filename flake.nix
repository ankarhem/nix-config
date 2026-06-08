{
  description = "MacOS System Configuration flake";

  inputs = {
    agent-browser.flake = false;
    agent-browser.url = "github:vercel-labs/agent-browser";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    blog.url = "git+https://github.com/ankarhem/site";
    comfyui-nix.url = "github:utensils/comfyui-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.url = "github:cachix/git-hooks.nix";
    graylog-cli.url = "github:norcetech/graylog-cli";
    hermes-agent.inputs.nixpkgs.follows = "nixpkgs";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    homebrew-bundle.flake = false;
    homebrew-bundle.url = "github:homebrew/homebrew-bundle";
    homebrew-cask.flake = false;
    homebrew-cask.url = "github:homebrew/homebrew-cask";
    homebrew-core.flake = false;
    homebrew-core.url = "github:homebrew/homebrew-core";
    homebrew-sikarugir.flake = false;
    homebrew-sikarugir.url = "github:Sikarugir-App/homebrew-sikarugir";
    import-tree.url = "github:vic/import-tree";
    # reset to upstream when merged https://github.com/pfassina/lazyvim-nix/pull/85
    lazyvim.url = "github:ankarhem/lazyvim-nix/fix/add-missing-nixpkg-mappings";
    llm-agents.url = "github:numtide/llm-agents.nix";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    norce-agent-instructions.flake = false;
    norce-agent-instructions.url = "github:NorceTech/agent-instructions";
    nur.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    plasma-manager.inputs.home-manager.follows = "home-manager";
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.url = "github:nix-community/plasma-manager";
    scripts.url = "github:ankarhem/scripts";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    temporalio-skill.flake = false;
    temporalio-skill.url = "github:temporalio/skill-temporal-developer";
    truesight.inputs.nixpkgs.follows = "nixpkgs";
    truesight.url = "github:ankarhem/truesight";
    vicinae-extensions.inputs.nixpkgs.follows = "nixpkgs";
    vicinae-extensions.url = "github:vicinaehq/extensions";
    vicinae.inputs.nixpkgs.follows = "nixpkgs";
    vicinae.url = "github:vicinaehq/vicinae";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      flake.overlays.default = final: prev: {
        local = self.packages.${prev.stdenv.hostPlatform.system};
      };
      perSystem =
        {
          lib,
          config,
          pkgs,
          ...
        }:
        {
          packages = lib.filterAttrs (_: drv: drv.meta.available or true) (
            lib.packagesFromDirectoryRecursive {
              inherit (pkgs) callPackage;
              directory = ./packages;
            }
          );
          pre-commit.settings.hooks = {
            ripsecrets.enable = true;
            nixfmt.enable = true;
          };
          formatter = pkgs.nixfmt-tree;
          devShells.default = pkgs.mkShell {
            packages = [ pkgs.act ] ++ config.pre-commit.settings.enabledPackages;
            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
          };
        };
    };
}
