{ lib, config, ... }:

let cfg = config.networking.custom;
in {
  options.networking.custom = {
    homelabIp = lib.mkOption {
      type = lib.types.strMatching "([0-9]{1,3}\\.){3}[0-9]{1,3}";
      description = "Full homelab server IP address";
    };

    synologyIp = lib.mkOption {
      type = lib.types.strMatching "([0-9]{1,3}\\.){3}[0-9]{1,3}";
      description = "Full Synology NAS IP address";
    };

    lanNetwork = lib.mkOption {
      type = lib.types.strMatching "([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}";
      description = "Full LAN network CIDR";
    };
  };

  config = lib.mkIf (cfg.homelabIp != "" && cfg.synologyIp != "" && cfg.lanNetwork != "") {
    assertions = [
      {
        assertion = builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}" cfg.homelabIp != null;
        message = "networking.custom.homelabIp must be a valid IP address";
      }
      {
        assertion = builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}" cfg.synologyIp != null;
        message = "networking.custom.synologyIp must be a valid IP address";
      }
      {
        assertion = builtins.match "([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}" cfg.lanNetwork != null;
        message = "networking.custom.lanNetwork must be a valid CIDR network";
      }
      {
        assertion = cfg.homelabIp != cfg.synologyIp;
        message = "homelabIp and synologyIp must be different addresses";
      }
      {
        assertion = 
          let 
            networkBase = lib.head (lib.splitString "/" cfg.lanNetwork);
            ipOctets = lib.splitString "." cfg.homelabIp;
            netOctets = lib.splitString "." networkBase;
          in
          builtins.length ipOctets == 4 && 
          builtins.length netOctets == 4 &&
          (builtins.elemAt ipOctets 0) == (builtins.elemAt netOctets 0) &&
          (builtins.elemAt ipOctets 1) == (builtins.elemAt netOctets 1) &&
          (builtins.elemAt ipOctets 2) == (builtins.elemAt netOctets 2);
        message = "homelabIp must be within the lanNetwork range";
      }
      {
        assertion = 
          let 
            networkBase = lib.head (lib.splitString "/" cfg.lanNetwork);
            ipOctets = lib.splitString "." cfg.synologyIp;
            netOctets = lib.splitString "." networkBase;
          in
          builtins.length ipOctets == 4 && 
          builtins.length netOctets == 4 &&
          (builtins.elemAt ipOctets 0) == (builtins.elemAt netOctets 0) &&
          (builtins.elemAt ipOctets 1) == (builtins.elemAt netOctets 1) &&
          (builtins.elemAt ipOctets 2) == (builtins.elemAt netOctets 2);
        message = "synologyIp must be within the lanNetwork range";
      }
    ];
  };
}

