{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.custom-scripts;

  # Individual script packages using writeShellApplication
  cloneOrg = pkgs.writeShellApplication {
    name = "clone_org";
    runtimeInputs = [ pkgs.gh ];
    text = builtins.readFile ./scripts/clone_org.sh;
  };

  summarize = pkgs.writeShellApplication {
    name = "summarize";
    runtimeInputs = [
      pkgs.jq
      pkgs.curl
    ];
    text = builtins.readFile ./scripts/summarize.sh;
  };

  ytSub = pkgs.writeShellApplication {
    name = "yt-sub";
    runtimeInputs = [ pkgs.yt-dlp ];
    text = builtins.readFile ./scripts/yt-sub.sh;
  };

  scriptPackages = [
    cloneOrg
    summarize
    ytSub
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
