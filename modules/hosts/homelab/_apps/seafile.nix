{ ... }:
{
  services.nginx.virtualHosts."seafile.ankarhem.dev" = {
    forceSSL = true;
    useACMEHost = "ankarhem.dev";
    locations."/".return = 404;
  };
}
