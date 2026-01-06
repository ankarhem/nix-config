{ inputs, config, ... }:
{
  flake.modules.nixos.ssh = {
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

  flake.modules.darwin.ssh = {
    # MacOS config: enable MacOS builtin ssh server, etc.
  };

  flake.modules.homeManager.ssh = {
    # setup ~/.ssh/config, authorized_keys, private keys secrets, etc.
  };

  perSystem =
    { pkgs, ... }:
    {
      # custom packages taking advantage of ssh facilities, eg deployment-scripts.
    };
}
