# Homelab host - NixOS LXC server
{
  inputs,
  lib,
  config,
  ...
}:
let
  username = "idealpink";
  hostname = "homelab";
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "olm-3.2.16" ];
    };
  };
  helpers = config.helpers;
in
{
  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit helpers username hostname;
      self = inputs.self;
      inherit inputs;
      inherit pkgs-unstable;
    };
    modules = [
      # Host-specific configuration
      "${inputs.self}/hosts/${hostname}/configuration/default.nix"

      # Dendritic aspects from modules.nixos.*
      inputs.self.modules.nixos.networking

      # External modules
      inputs.sops-nix.nixosModules.sops

      # Home Manager integration
      inputs.home-manager.nixosModules.home-manager
      {
        # NixOS configuration
        networking.custom = {
          homelabIp = "192.168.1.221";
          synologyIp = "192.168.1.163";
          lanNetwork = "192.168.1.0/24";
        };

        # Set hostname
        networking.hostName = hostname;

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit
            pkgs-unstable
            helpers
            inputs
            username
            ;
          self = inputs.self;
        };
        home-manager.users.${username} = {
          imports = [
            # Dendritic aspects from modules.homeManager.*
            inputs.self.modules.homeManager.fish
            inputs.self.modules.homeManager.git
            inputs.self.modules.homeManager.gh
            inputs.self.modules.homeManager.gpg
            inputs.self.modules.homeManager.neovim

            # Host-specific home configuration
            "${inputs.self}/hosts/${hostname}/home/default.nix"
          ];

          # Override home username and directory
          home.username = username;
          home.homeDirectory = "/home/${username}";
          home.stateVersion = "24.05";

          # Git SSH signing configuration
          home.file.".config/git/allowed_signers".text =
            let
              authorizedKeys = helpers.ssh.getGithubKeys {
                username = "ankarhem";
                sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
              };
              allowedSigners = lib.concatStringsSep "\n" (map (key: "* ${key}") authorizedKeys);
            in
            allowedSigners;
          programs.git = {
            signing.key = "~/.ssh/id_ed25519.pub";
            settings.gpg.format = "ssh";
            settings.gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
          };

          # nix-index
          programs.nix-index-database.comma.enable = true;
          programs.nix-index.enable = true;

          # Other programs
          programs.zoxide.enable = true;
          programs.eza.enable = true;
        };
      }
    ];
  };
}
