{ inputs, ... }:
{
  # Disabled - workstation is not in use (see #42)
  # flake.nixosConfigurations = inputs.self.factory.nixos "x86_64-linux" "workstation";
}
