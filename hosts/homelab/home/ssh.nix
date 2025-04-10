{ ... }: {
  programs.ssh = {
    enable = true;

    extraConfig = ''
      Host *
        IdentityFile ~/.ssh/id_ed25519
      Host github.com
        User git
        HostName github.com
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
        # Persist connection for 60min
        ControlMaster auto
        ControlPath ~/.ssh/S.%r@%h:%p
        ControlPersist 60m
    '';
  };
}
