{ inputs, config, ... }:
{
  flake.modules.nixos.colemak = {
    services.xserver.xkb = {
      layout = "us";
      variant = "colemak";
    };
    # services.keyd = {
    #   enable = true;
    #   keyboards = {
    #     default = {
    #       ids = [ "*" ];
    #       settings = {
    #         main = {
    #           capslock = "escape";
    #           leftalt = "leftmeta";
    #           leftmeta = "leftalt";
    #           rightalt = "rightmeta";
    #           rightmeta = "rightalt";
    #         };
    #       };
    #     };
    #   };
    # };
  };

  flake.modules.darwin.colemak = {
    home-manager.sharedModules = [ inputs.self.modules.homeManager.colemak ];

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

  flake.modules.homeManager.colemak =
    { pkgs, lib, ... }:
    let
      colemakKeylayout = pkgs.fetchurl {
        url = "https://colemak.com/pub/mac/Colemak.keylayout";
        hash = "sha256-dASDHgkNCm8aPNNg7pvUhJh7sx5aCExI8Ea8dim3ZZU=";
      };
    in
    {
      # macOS only picks up real files in ~/Library/Keyboard Layouts (not
      # symlinks), so copy the pinned keylayout instead of linking it.
      home.activation.colemakLayout = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        layout="$HOME/Library/Keyboard Layouts/Colemak.keylayout"
        if ! cmp -s "${colemakKeylayout}" "$layout"; then
          $DRY_RUN_CMD mkdir -p "$(dirname "$layout")"
          $DRY_RUN_CMD cp -f "${colemakKeylayout}" "$layout"
          $DRY_RUN_CMD chmod 644 "$layout"
        fi
      '';
    };
}
