{ inputs, ... }:
{
  flake.modules.homeManager.ssh =
    { pkgs, ... }:
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
            HostName = "homelab.local";
            User = "idealpink";
            Port = 22;
            IdentitiesOnly = true;
            IdentityFile = [
              "~/.ssh/id_ed25519"
              "~/.ssh/id_ed25519_sk"
              "~/.ssh/id_ecdsa_sk"
            ];
          };
        };
      };
    };
}
