{ config, lib, ... }:
with lib;
{
  options = {
    system.defaults."NSGlobalDomain"."com.apple.mouse.linear" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        When disabled, the pointer will move more quickly for fast mouse movements and more precisely for slow mouse movements.
        Found in the "Mouse > Advanced" section of "System Preferences". Set to true to disable pointer acceleration.
      '';
    };
    system.defaults.".GlobalPreferences"."com.apple.mouse.linear" = mkOption {
      type = types.nullOr types.bool;
      default = null;
      example = true;
      description = ''
        When disabled, the pointer will move more quickly for fast mouse movements and more precisely for slow mouse movements.
        Found in the "Mouse > Advanced" section of "System Preferences". Set to true to disable pointer acceleration.
      '';
    };
  };
}
