{
  flake.modules.nixos.sshd = {
    services.openssh = {
      enable = true;
      settings = {
        LoginGraceTime = 30;
        MaxAuthTries = 3;
        MaxStartups = "10:30:60";
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
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
