{ lib, ... }:
let
  toInt = lib.strings.toInt;

  ports = {
    http = "8088";
    https = "8043";
    # portal-http = "8088";
    # portal-https = "8843";

    app-discovery = "27001"; # UDP
    discovery = "29810"; # UDP
    manager-v1 = "29811";
    adopt-v1 = "29812";
    upgrade-v1 = "29813";
    manager-v2 = "29814";
    transfer-v2 = "29815";
    rtty = "29816";
  };

  udpPorts = [ ports.app-discovery ports.discovery ];
  tcpPorts = builtins.filter (port: !builtins.elem port udpPorts)
    (builtins.attrValues ports);
in {
  networking.firewall.allowedTCPPorts = map toInt tcpPorts;
  networking.firewall.allowedUDPPorts = map toInt udpPorts;

  services.nginx.virtualHosts."omada.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = { proxyPass = "https://127.0.0.1:${ports.https}"; };
  };

  virtualisation.oci-containers.containers."omada-controller" = {
    image = "mbentley/omada-controller:5.15";
    environment = {
      "MANAGE_HTTP_PORT" = ports.http;
      "MANAGE_HTTPS_PORT" = ports.https;
      "PORTAL_HTTP_PORT" = ports.http;
      "PORTAL_HTTPS_PORT" = ports.https;
      "PORT_APP_DISCOVERY" = ports.app-discovery;
      "PORT_DISCOVERY" = ports.discovery;
      "PORT_MANAGER_V1" = ports.manager-v1;
      "PORT_ADOPT_V1" = ports.adopt-v1;
      "PORT_UPGRADE_V1" = ports.upgrade-v1;
      "PORT_MANAGER_V2" = ports.manager-v2;
      "PORT_TRANSFER_V2" = ports.transfer-v2;
      "PORT_RTTY" = ports.rtty;
      "SHOW_MONGODB_LOGS" = "false";
      "SHOW_SERVER_LOGS" = "true";
      "TZ" = "Europe/Stockholm";
    };
    ports = (builtins.map (port: "${port}:${port}") tcpPorts)
      ++ (builtins.map (port: "${port}:${port}/udp") udpPorts);
    volumes = [
      "/var/lib/omada/data:/opt/tplink/EAPController/data:rw"
      "/var/lib/omada/logs:/opt/tplink/EAPController/logs:rw"
    ];
  };
}
