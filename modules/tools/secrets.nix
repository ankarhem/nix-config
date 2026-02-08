{ inputs, self, ... }:
let
  home-manager.sharedModules = [
    inputs.self.modules.homeManager.secrets
  ];
  sops = {
    defaultSopsFile = "${self}/secrets.json";
    defaultSopsFormat = "json";
    age.generateKey = true;
  };
in
{
  flake.modules.nixos.secrets =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];
      inherit home-manager sops;
    };
  flake.modules.darwin.secrets = {
    imports = [
      inputs.sops-nix.darwinModules.sops
    ];
    inherit home-manager sops;
  };
  flake.modules.homeManager.secrets = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    inherit sops;
  };
}
