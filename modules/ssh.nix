{ inputs, ... }:
{
  flake.modules.homeManager.ssh =
    { pkgs, lib, ... }:
    let
      # Identity files used for the homelab box (admin login and knot pushes).
      homelabKeys = [
        "~/.ssh/id_ed25519"
        "~/.ssh/id_ed25519_sk"
        "~/.ssh/id_ecdsa_sk"
      ];

      homelabLanIp = "192.168.1.221";
    in
    {
      home.packages = with pkgs; [
        yubikey-personalization
        yubikey-manager
      ];

      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "*" = {
            IdentityFile = [ "~/.ssh/id_ed25519" ];
          };
          "github.com" = {
            User = "git";
            HostName = "github.com";
            IdentitiesOnly = true;
            IdentityFile = [ "~/.ssh/id_ed25519" ];
            ControlMaster = "auto";
            ControlPath = "~/.ssh/S.%r@%h:%p";
            ControlPersist = "60m";
          };
          "synology" = {
            SetEnv = {
              TERM = "xterm-256color";
            };
            HostName = "disketten.local";
            User = "idealpink";
            Port = 1337;
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/id_ed25519_sk"
              "~/.ssh/id_ecdsa_sk"
            ];
          };
          "homelab" = {
            HostName = homelabLanIp;
            User = "idealpink";
            Port = 22;
            IdentitiesOnly = true;
            IdentityFile = homelabKeys;
          };
          # Tangled knot. The git user is no-pty, so Ghostty's ssh-terminfo
          # install hangs/fails on every connect. Prime the cache to skip it:
          #   ghostty +ssh-cache --add=git@knot.ankarhem.dev
          "knot.ankarhem.dev" = {
            HostName = homelabLanIp;
            User = "git";
            Port = 22;
            IdentitiesOnly = true;
            IdentityFile = homelabKeys;
          };
        };
      };
    };
}
