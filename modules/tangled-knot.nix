{ inputs, ... }: {
  flake.modules.nixos.tangled-knot =
    { config, lib, ... }:
    let
      domain = "knot.ankarhem.dev";
      internalPort = "5444";
      publicPort = "5555";

      cfg = config.services.tangled.knot;
    in
    {
      imports = [
        inputs.tangled.nixosModules.knot
      ];
      services.tangled.knot = {
        enable = true;
        package = inputs.tangled.packages.${config.nixpkgs.hostPlatform.system}.knot;
        gitUser = "git";
        stateDir = "/var/lib/tangled-knot";
        repo.scanPath = "/mnt/DISKETTEN_drive/tangled/repos";
        server = {
          listenAddr = "127.0.0.1:${publicPort}";
          internalListenAddr = "127.0.0.1:${internalPort}";
          hostname = domain;
          owner = "did:plc:freiumm55hanqgziwfajvhn6";
        };
        openFirewall = false;
      };
      systemd.services.knot.serviceConfig = {
        MemoryMax = "4G";
        MemorySwapMax = "0";
      };

      systemd.services.knot.preStart =
        let
          setMotd =
            if cfg.motdFile != null && cfg.motd != null then
              throw "motdFile and motd cannot be both set"
            else
              ''
                ${lib.optionalString (cfg.motdFile != null) "cat ${cfg.motdFile} > ${cfg.stateDir}/motd"}
                ${lib.optionalString (cfg.motd != null) ''printf "${cfg.motd}" > ${cfg.stateDir}/motd''}
              '';
        in
        ''
          mkdir -p "${cfg.repo.scanPath}"
          # disabled because of root_squash on NFSv3 mount (Synology)
          # chown -R ${cfg.gitUser}:${cfg.gitUser} "${cfg.repo.scanPath}"

          mkdir -p "${cfg.stateDir}/.config/git"
          cat > "${cfg.stateDir}/.config/git/config" << EOF
          [user]
              name = ${cfg.git.userName}
              email = ${cfg.git.userEmail}
          [receive]
              advertisePushOptions = true
          [uploadpack]
              allowFilter = true
              allowReachableSHA1InWant = true
          EOF
          ${setMotd}
          chown -R ${cfg.gitUser}:${cfg.gitUser} "${cfg.stateDir}"
        '';

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        locations."/" = {
          proxyPass = "http://127.0.0.1:${publicPort}";
        };
        locations."/events" = {
          proxyPass = "http://127.0.0.1:${publicPort}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_read_timeout 86400s;
          '';
        };
      };

      services.fail2ban.jails.sshd.settings = {
        enabled = true;
        maxretry = 3;
      };
    };
}
