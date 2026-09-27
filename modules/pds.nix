{ ... }:
let
  port = 4678;
  domain = "pds.ankarhem.dev";
in
{
  flake.modules.nixos.pds =
    { config, ... }:
    {
      sops.secrets."pds/jwt_secret" = { };
      sops.secrets."pds/admin_password" = { };
      sops.secrets."pds/plc_rotation_key" = { };

      sops.templates."pds.env".content = ''
        PDS_JWT_SECRET=${config.sops.placeholder."pds/jwt_secret"}
        PDS_ADMIN_PASSWORD=${config.sops.placeholder."pds/admin_password"}
        PDS_PLC_ROTATION_KEY_K256_PRIVATE_KEY_HEX=${config.sops.placeholder."pds/plc_rotation_key"}
      '';

      services.bluesky-pds = {
        enable = true;
        pdsadmin.enable = true;
        environmentFiles = [ config.sops.templates."pds.env".path ];
        settings = {
          PDS_HOSTNAME = domain;
          PDS_PORT = port;
        };
      };

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        extraConfig = ''
          client_max_body_size 100m;
        '';
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
}
