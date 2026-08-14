{
  flake.modules.nixos.apotekskarta =
    { config, ... }:
    {
      sops.secrets."geoapify_key" = { };

      sops.templates."apotekskarta.env".content = ''
        GEOAPIFY_API_KEY=${config.sops.placeholder."geoapify_key"}
      '';

      systemd.services.apotekskarta =
        let
          profile = "/nix/var/nix/profiles/per-user/root/apotekskarta";
          binary = "${profile}/bin/apotekskarta";
        in
        {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          unitConfig.ConditionPathExists = binary;
          serviceConfig = {
            ExecStart = binary;
            WorkingDirectory = "/var/lib/apotekskarta";
            StateDirectory = "apotekskarta";
            Restart = "always";
            RestartSec = "5s";
            EnvironmentFile = config.sops.templates."apotekskarta.env".path;
          };
          environment = {
            PORT = "7035";
          };
        };

      services.nginx.virtualHosts."apotekskarta.internetfeno.men" = {
        forceSSL = true;
        useACMEHost = "internetfeno.men";
        locations."/".proxyPass = "http://127.0.0.1:7035";
      };
    };
}
