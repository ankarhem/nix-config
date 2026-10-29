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
  flake.modules.homeManager.gh = { pkgs, ... }: {
    programs.gh = {
      enable = true;
      package = pkgs._unstable.gh;

      extensions = [ pkgs._unstable.gh-stack ];
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
