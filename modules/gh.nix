{ inputs, ... }:
let
  home-manager.sharedModules = [
    inputs.self.modules.homeManager.gh
  ];
in
{
  flake.modules.nixos.gh = {
    inherit home-manager;
  };
  flake.modules.darwin.gh = {
    inherit home-manager;
  };
  flake.modules.homeManager.gh = {
    programs.gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
        prompt = "enabled";

        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };
  };
}
