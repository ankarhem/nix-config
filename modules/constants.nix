{ inputs, ... }:
{
  flake.modules.generic.constants =
    { lib, ... }:
    {
      options.constants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.constants = {
        email = "jakob@ankarhem.dev";
        # adminEmail = "admin@internetfeno.men";
      };
    };
}
