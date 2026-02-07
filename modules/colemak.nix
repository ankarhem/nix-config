{ inputs, config, ... }:
{
  flake.modules.nixos.colemak = {
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak";
    };
    services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "escape";
              leftalt = "leftmeta";
              leftmeta = "leftalt";
              rightalt = "rightmeta";
              rightmeta = "rightalt";
            };
          };
        };
      };
    };
  };

  flake.modules.darwin.colemak = {
    system.keyboard.enableKeyMapping = true;
    system.keyboard.remapCapsLockToEscape = true;
    system.keyboard.userKeyMapping = [
      {
        # Right Command to Option
        HIDKeyboardModifierMappingSrc = 30064771303;
        HIDKeyboardModifierMappingDst = 30064771302;
      }
    ];
  };
}
