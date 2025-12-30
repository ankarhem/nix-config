{ ... }:
{

  # Download profile from https://jetshop.openvpn.com/devices
  # Import and connect to profile
  # openvpn3 config-import --config ./norce.ovpn --name NorceVPN --persistent
  # openvpn3 session-start --config NorceVPN
  programs.openvpn3.enable = true;

  # https://github.com/NixOS/nixpkgs/pull/396940
  services.resolved.enable = true;
}
