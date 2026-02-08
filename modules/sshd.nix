{
  flake.modules.nixos.sshd = {
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
  flake.modules.darwin.sshd = {
    services.openssh = {
      enable = true;
      extraConfig = ''
        StreamLocalBindUnlink yes
        PermitRootLogin prohibit-password
        PasswordAuthentication no
      '';
    };
  };
}
