# modules/ssh.nix -- like every other file inside modules, this is a flake-parts module.
{ inputs, config, ... }:
let
  scpPort = 2277; # let-bindings or custom flake-parts options communicate values across classes
in
{
  flake.modules.nixos.ssh = {
    # Linux config: setup OpenSSH server, firewall-ports, etc.
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
