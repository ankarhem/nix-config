_: let
  onePassPath = "\"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock\"";
in {
  programs.ssh = {
    enable = true;

    extraConfig = ''
      Host *
        IdentityAgent ${onePassPath}
      Host github.com
        User git
        HostName github.com
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_sk # byt ut denna till din ssh-nyckel
        # Persist connection for 60min
        ControlMaster auto
        ControlPath ~/.ssh/S.%r@%h:%p
        ControlPersist 60m
      Host synology
        HostName disketten.local
        User idealpink
        Port 1337
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_sk
        IdentityFile ~/.ssh/id_ecdsa_sk
      Host tower
        HostName tower.local
        User root
        Port 1337
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519_sk
        IdentityFile ~/.ssh/id_ecdsa_sk
    '';
  };
}
