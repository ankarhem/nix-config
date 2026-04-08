let
  sharedModule =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        attic-client
      ];
      nix.settings = {
        substituters = [
          "https://attic.internetfeno.men/main"
        ];

        trusted-public-keys = [
          "main:9AeGSCEdFACRMznpA8b1LZtZ6cLkpdeTQ0Hqa0RmQAA="
        ];
      };
    };

in
{
  flake.modules.nixos.attic-client = {
    imports = [ sharedModule ];
  };
  flake.modules.darwin.attic-client = {
    imports = [ sharedModule ];
  };
}
