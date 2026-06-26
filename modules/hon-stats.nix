{ inputs, ... }:
{
  flake.modules.nixos.hon-stats =
    { config, pkgs, ... }:
    {
      systemd.tmpfiles.rules = [
        "L+ /var/lib/hon-stats/current - - - - ${
          inputs.hon-stats.packages.${pkgs.hostPlatform.system}.hon-stats
        }"
      ];

      sops.secrets."hon-stats/juvio-username-0" = { };
      sops.secrets."hon-stats/juvio-username-1" = { };
      sops.secrets."hon-stats/juvio-username-2" = { };
      sops.secrets."hon-stats/juvio-username-3" = { };
      sops.secrets."hon-stats/juvio-password" = { };

      sops.templates."hon-stats.env".content = ''
        HonStats__Juvio__Accounts__0__Username=${config.sops.placeholder."hon-stats/juvio-username-0"}
        HonStats__Juvio__Accounts__0__Password=${config.sops.placeholder."hon-stats/juvio-password"}
        HonStats__Juvio__Accounts__1__Username=${config.sops.placeholder."hon-stats/juvio-username-1"}
        HonStats__Juvio__Accounts__1__Password=${config.sops.placeholder."hon-stats/juvio-password"}
        HonStats__Juvio__Accounts__2__Username=${config.sops.placeholder."hon-stats/juvio-username-2"}
        HonStats__Juvio__Accounts__2__Password=${config.sops.placeholder."hon-stats/juvio-password"}
        HonStats__Juvio__Accounts__3__Username=${config.sops.placeholder."hon-stats/juvio-username-3"}
        HonStats__Juvio__Accounts__3__Password=${config.sops.placeholder."hon-stats/juvio-password"}
      '';

      systemd.services.hon-stats = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = {
          ExecStart = "/var/lib/hon-stats/current/bin/hon-stats";
          WorkingDirectory = "/var/lib/hon-stats";
          StateDirectory = "hon-stats";
          Restart = "always";
          RestartSec = "5s";
          EnvironmentFile = config.sops.templates."hon-stats.env".path;
        };
        environment = {
          ASPNETCORE_URLS = "http://127.0.0.1:7034";
          HonStats__Persistence__ConnectionString = "Data Source=/var/lib/hon-stats/honstats.db";
        };
      };

      services.nginx.virtualHosts."hon.internetfeno.men" = {
        forceSSL = true;
        useACMEHost = "internetfeno.men";
        locations."/".proxyPass = "http://127.0.0.1:7034";
      };
    };
}
