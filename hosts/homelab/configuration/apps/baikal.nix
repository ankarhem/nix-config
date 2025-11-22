{ ... }:
let domain = "baikal.internetfeno.men";
in {
  services.baikal = {
    enable = true;
    virtualHost = "${domain}";
  };
  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = "internetfeno.men";
  };
}
