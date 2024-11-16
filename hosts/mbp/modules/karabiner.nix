{...}: let
  swapIfNotTerminal = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {optional = ["any"];};
    };
    to = [{key_code = to;}];
    conditions = [
      {
        type = "frontmost_application_unless";
        bundle_identifiers = [
          "^com\\.apple\\.Terminal$"
          "^net\\.kovidgoyal\\.kitty$"
        ];
      }
    ];
  };
  swapIfInternal = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {optional = ["any"];};
    };
    to = [{key_code = to;}];
    conditions = [
      {
        type = "device_if";
        identifiers = [{is_built_in_keyboard = true;}];
      }
    ];
  };

  swap = from: to: {
    type = "basic";
    from = {
      key_code = from;
      modifiers = {optional = ["any"];};
    };
    to = [{key_code = to;}];
    conditions = [];
  };
in {
  home.file.karabiner = {
    target = ".config/karabiner/assets/complex_modifications/nix.json";
    text = builtins.toJSON {
      title = "Nix Managed";
      rules = [
        {
          description = "Modifications managed by Nix";
          manipulators = [
            # for colemak
            (swap "right_command" "right_option")
          ];
        }
      ];
    };
  };
}
