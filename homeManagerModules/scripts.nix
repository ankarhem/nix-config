{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.custom-scripts;

  cloneOrg = pkgs.writeShellApplication {
    name = "clone_org";
    runtimeInputs = [ pkgs.gh ];
    text = builtins.readFile ./scripts/clone_org.sh;
  };

  scriptPackages = [
    cloneOrg
  ];
in
{
  options = {
    modules.custom-scripts = {
      enable = mkEnableOption "Enable custom scripts module";
    };
  };

  config = mkIf cfg.enable { home.packages = scriptPackages; };
}
