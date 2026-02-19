{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.factory.nixos "x86_64-linux" "homelab";
}
