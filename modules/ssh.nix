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
  };

  flake.modules.homeManager.ssh =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yubikey-personalization
        yubikey-manager
        openssh
      ];

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
          };
        };
      };

      # TODO: Create this using pkgs.writeShellApplication instead
      programs.fish.loginShellInit = ''
        function copy-term-info
          infocmp -x | ssh $argv[1] -- tic -x -
        end
      '';
    };
}
