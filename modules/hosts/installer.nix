# Installer host - NixOS LXC installer
{
  inputs,
  lib,
  config,
  ...
}:
{
  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      helpers = config.helpers;
      self = inputs.self;
      inherit inputs;
    };
    modules = [
      {
        # Provide hostname for installer
        networking.hostName = "installer";
      }
      "${inputs.self}/hosts/installer/configuration.nix"
    ];
  };
}
