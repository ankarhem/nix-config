{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.custom-scripts;

  scriptsDir = ./scripts;
  scriptsDirContents = builtins.readDir scriptsDir;

  # Filter only regular files ending with .sh
  shFiles =
    lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".sh" name)
    scriptsDirContents;

  # Create a package for each script
  scriptPackages = lib.mapAttrsToList (name: _:
    let
      # Remove .sh extension from filename
      scriptName = lib.removeSuffix ".sh" name;
      # Get full path to script
      scriptPath = scriptsDir + "/${name}";
    in pkgs.writeShellScriptBin scriptName (builtins.readFile scriptPath))
    shFiles;
in {
  options = {
    modules.custom-scripts = {
      enable = mkEnableOption "Enable custom scripts module";
    };
  };

  config = mkIf cfg.enable { home.packages = scriptPackages; };
}
