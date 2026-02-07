{
  inputs,
  ...
}:
{
  flake.darwinConfigurations = inputs.self.factory.darwin "aarch64-darwin" "mbp";
}
