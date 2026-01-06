{ inputs, config, ... }:
{
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
      };
      extraConfig = ''
        StreamLocalBindUnlink yes
      '';
    };
  };

  flake.modules.darwin.ssh = {
    # MacOS config: enable MacOS builtin ssh server, etc.
  };

  flake.modules.homeManager.ssh = {
    # setup ~/.ssh/config, authorized_keys, private keys secrets, etc.
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          identityFile = [ "~/.ssh/id_ed25519" ];
        };
        "github.com" = {
          user = "git";
          hostname = "github.com";
          identitiesOnly = true;
          identityFile = [ "~/.ssh/id_ed25519" ];
          controlMaster = "auto";
          controlPath = "~/.ssh/S.%r@%h:%p";
          controlPersist = "60m";
        };
        "synology" = {
          setEnv = {
            TERM = "xterm-256color";
          };
          hostname = "disketten.local";
          user = "idealpink";
          port = 1337;
          identitiesOnly = true;
          identityFile = [
            "~/.ssh/id_ed25519_sk"
            "~/.ssh/id_ecdsa_sk"
          ];
        };
        "homelab" = {
          hostname = "homelab.local";
          user = "idealpink";
          port = 22;
          identitiesOnly = true;
          identityFile = [
            "~/.ssh/id_ed25519"
            "~/.ssh/id_ed25519_sk"
            "~/.ssh/id_ecdsa_sk"
          ];
          remoteForwards = [
            {
              bind.address = "/run/user/1000/gnupg/S.gpg-agent";
              host.address = "/Users/ankarhem/.gnupg/S.gpg-agent";
            }
          ];
        };
      };
    };
  };

  perSystem =
    { pkgs, ... }:
    {
      # custom packages taking advantage of ssh facilities, eg deployment-scripts.
    };
}
