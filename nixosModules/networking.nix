{ lib, config, ... }:

let cfg = config.networking.custom;
in {
  options.networking.custom = {
    homelabIp = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Full homelab server IP address";
    };

    synologyIp = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Full Synology NAS IP address";
    };

    lanNetwork = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Full LAN network CIDR";
    };
  };

  config = lib.mkIf
    (cfg.homelabIp != "" && cfg.synologyIp != "" && cfg.lanNetwork != "") ({
      assertions = [
        {
          assertion =
            builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}" cfg.homelabIp != null;
          message = "networking.custom.homelabIp must be a valid IP address";
        }
        {
          assertion =
            builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}" cfg.synologyIp
            != null;
          message = "networking.custom.synologyIp must be a valid IP address";
        }
        {
          assertion = builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}"
            cfg.lanNetwork != null;
          message = "networking.custom.lanNetwork must be a valid CIDR network";
        }
        {
          assertion = cfg.homelabIp != cfg.synologyIp;
          message = "homelabIp and synologyIp must be different addresses";
        }
      ];
    });
}

