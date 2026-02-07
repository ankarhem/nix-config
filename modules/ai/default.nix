{ inputs, ... }:
{
  flake.modules.nixos.ai = {
    imports = with inputs.self.modules.nixos; [
      opencode
      mcp
    ];
  };
  flake.modules.darwin.ai = {
    imports = with inputs.self.modules.darwin; [
      opencode
      mcp
    ];
  };
}
