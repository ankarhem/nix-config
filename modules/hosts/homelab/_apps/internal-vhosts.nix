{ config, lib, ... }:
let
  internalZones = [
    "internal.internetfeno.men"
    "internal.ankarhem.dev"
  ];
  allowed = [
    config.networking.custom.lanNetwork
    "100.64.0.0/10" # tailscale
    "fd7a:115c:a1e0::/48" # tailscale
    "172.16.0.0/12" # docker
    config.networking.custom.wanIp # the router's NAT loopback rewrites LAN clients to it
  ];
in
{
  # nginx serves any Host on the public IP, so internal names are only hidden by DNS.
  options.services.nginx.virtualHosts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          config.extraConfig = lib.mkIf (lib.any (z: lib.hasSuffix ".${z}" name) internalZones) ''
            ${lib.concatMapStrings (a: "allow ${a};\n") allowed}deny all;
          '';
        }
      )
    );
  };
}
