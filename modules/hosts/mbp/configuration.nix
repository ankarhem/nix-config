{ inputs, ... }:
{
  flake.modules.darwin.mbp = {
    imports = with inputs.self.modules.darwin; [
      ai
    ];
  };
}
