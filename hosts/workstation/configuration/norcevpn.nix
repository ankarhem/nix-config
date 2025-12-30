{ ... }:
{
  programs.openvpn3.enable = true;

  # https://github.com/NixOS/nixpkgs/pull/396940
  services.resolved.enable = true;
}
