{ inputs, config, ... }:
{
  flake.modules.nixos.norcevpn = {
    # Download profile from https://jetshop.openvpn.com/devices
    # Import and connect to profile
    # openvpn3 config-import --config ./norce.ovpn --name NorceVPN --persistent
    # openvpn3 session-start --config NorceVPN
    # openvpn3 session-manage --config NorceVPN --disconnect
    programs.openvpn3.enable = true;

    # Helper aliases
    environment.shellAliases = {
      norcevpn-up = "openvpn3 session-start --config NorceVPN";
      norcevpn-down = "openvpn3 session-manage --config NorceVPN --disconnect";
    };

    # https://github.com/NixOS/nixpkgs/pull/396940
    services.resolved.enable = true;
  };

  flake.modules.darwin.norcevpn = {
    homebrew.casks = [
      "openvpn-connect"
    ];
  };
}
