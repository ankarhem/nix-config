{ inputs, ... }:
{
  flake.nixosConfigurations.homelab = inputs.self.factory.nixos "x86_64-linux" "homelab";
}
