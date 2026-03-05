{ config, ... }:
{
  imports = [
    ./module.nix
  ];

  sops.secrets."happier/master_secret" = { };
  sops.templates."happier-server.env".content = ''
    OPENCODE_SERVER_PASSWORD=${config.sops.placeholder."happier/master_secret"}
  '';

  services.opencode-server = {
    enable = true;
    user = "idealpink"; # refactor to a dedicated user later
    environmentFiles = [ config.sops.templates."happier-server.env".path ];
    workingDir = "/home/idealpink/repos";
  };

  services.nginx.virtualHosts."opencode.internal.internetfeno.men" = {
    forceSSL = true;
    useACMEHost = "internal.internetfeno.men";
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.opencode-server.port}";
    };
  };
}
