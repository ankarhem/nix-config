{ inputs, config, ... }:
{
  flake.modules.nixos.network = {
    networking.networkmanager.enable = true;
    # Enable CUPS to print documents.
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
    services.avahi.publish = {
      enable = true;
      addresses = true;
    };
  };

  flake.modules.darwin.network = {
    # MacOS config: enable MacOS builtin ssh server, etc.
  };

  flake.modules.homeManager.network = {
    # setup ~/.ssh/config, authorized_keys, private keys secrets, etc.
  };
}
