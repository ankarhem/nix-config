{
  inputs,
  ...
}:
let
  home-manager.sharedModules = with inputs.self.modules.homeManager; [
    claude
    mcp
    opencode
    skills
  ];
in
{
  flake.modules.nixos.ai = {
    inherit home-manager;
  };
  flake.modules.darwin.ai = {
    inherit home-manager;
  };
}
