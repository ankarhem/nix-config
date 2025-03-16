_: let
  onePassPath = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
in {
  programs.ssh = {
    enable = true;

    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
        # Persist connection for 5min
        ControlMaster auto
        ControlPath ~/.ssh/S.%r@%h:%p
        ControlPersist 5m
      Host github.com
        User git
        HostName github.com
        IdentityAgent ${onePassPath}
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
        # Persist connection for 60min
        ControlPersist 60m
      Host synology
        SetEnv TERM=xterm-256color
        HostName disketten.local
        User idealpink
        Port 1337
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_sk
        IdentityFile ~/.ssh/id_ecdsa_sk
      Host homelab
        HostName homelab.local
        User idealpink
        Port 22
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_sk
        IdentityFile ~/.ssh/id_ecdsa_sk
        IdentityFile ~/.ssh/id_ed25519
        RemoteForward /run/user/1000/gnupg/S.gpg-agent /Users/ankarhem/.gnupg/S.gpg-agent.extra
        # RemoteForward /home/idealpink/.gnupg/S.gpg-agent /Users/ankarhem/.gnupg/S.gpg-agent.extra
    '';
  };
}
