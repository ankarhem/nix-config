{
  config,
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
let
in
{
  imports = [
    inputs.vicinae.homeManagerModules.default
  ];

}
