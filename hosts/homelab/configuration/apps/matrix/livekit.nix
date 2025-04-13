{ self, config, pkgs, ... }:
let
  ports = {
    livekit = 7880;
    webrtc = {
      tcp = 7881;
      udp_start = 50000;
      udp_end = 51000;
    };
  };
  configFile = pkgs.writeTextFile {
    name = "livekit-config.yaml";
    text = builtins.toJSON {
      port = ports.livekit;
      log_level = "info";
      rtc = {
        tcp_port = ports.webrtc.tcp;
        port_range_start = ports.webrtc.udp_start;
        port_range_end = ports.webrtc.udp_end;
        use_external_ip = false;
      };
    };
  };
in {
  services.nginx.virtualHosts."livekit.internetfeno.men" = {
    useACMEHost = "internetfeno.men";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString ports.livekit}";
      proxyWebsockets = true;
    };
  };

  sops.secrets.livekit_keys = {
    sopsFile = "${self}/secrets/homelab/livekit_keys.json";
    format = "json";
  };
  systemd.services.livekit = {
    enable = true;
    description = "LiveKit SFU server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.livekit.package}/bin/livekit-server --config=${configFile} --key-file=${config.sops.secrets.livekit_keys.path}";
      Restart = "always";
      RestartSec = "5";
      User = "livekit";
      Group = "livekit";
    };
  };

  users.users.livekit = {
    isSystemUser = true;
    group = "livekit";
    description = "LiveKit service user";
  };

  users.groups.livekit = { };

  networking.firewall = {
    allowedTCPPorts = [ ports.livekit ports.rtc.tcp_port ];
    allowedUDPPortRanges = [{
      from = ports.rtc.port_range_start;
      to = ports.rtc.port_range_end;
    }];
  };
}
