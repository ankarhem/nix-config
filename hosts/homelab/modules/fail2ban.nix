{config, pkgs,...}: let
  realIpsFromList = pkgs.lib.strings.concatMapStringsSep "\n" (x: "set_real_ip_from  ${x};");
  fileToList = x: pkgs.lib.strings.splitString "\n" (builtins.readFile x);

  cfipv4 = fileToList (builtins.fetchurl {
    url = "https://www.cloudflare.com/ips-v4";
    sha256 = "0ywy9sg7spafi3gm9q5wb59lbiq0swvf0q3iazl0maq1pj1nsb7h";
  });
  cfipv6 = fileToList (builtins.fetchurl {
    url = "https://www.cloudflare.com/ips-v6";
    sha256 = "1ad09hijignj6zlqvdjxv7rjj8567z357zfavv201b9vx3ikk7cy";
  });
in {
  services.nginx.appendHttpConfig = ''
    ${realIpsFromList cfipv4}
    ${realIpsFromList cfipv6}
    real_ip_header CF-Connecting-IP;
  '';

  services.fail2ban = {
    enable = true;
    bantime-increment.enable = true;
    extraPackages = [ pkgs.curl ];
    jails = {
      nginx-http-auth.settings.enabled = true;
      nginx-botsearch.settings.enabled = true;
      nginx-bad-request.settings.enabled = true;
      # nginx-forbidden.settings.enabled = true;

      nginx-bruteforce.settings = {
        enabled = true;
        filter = "nginx-bruteforce";
        logpath = "/var/log/nginx/*.log";
        backend = "auto";
        findtime = "1d";
        action  = ''
          cf
          iptables-multiport[port="http,https"]
        '';
      };
    };
  };

  sops.secrets.cloudflare_global_api_key = {};
  sops.secrets.cloudflare_username = {};
  sops.templates."cloudflare-action.conf".content = ''
    [Definition]

    actionstart =
    actionstop =
    actioncheck =

    actionban = ${pkgs.curl} -s -o /dev/null -X POST 
          -H "X-Auth-Email: <cfuser>" 
          -H "X-Auth-Key: <cftoken>" 
          -H "Content-Type: application/json" 
          -d '{"mode":"block","configuration":{"target":"ip","value":"<ip>"},"notes":"Fail2Ban <name>"}' 
          "https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules"

    actionunban = ${pkgs.curl} -s -o /dev/null -X DELETE -H 'X-Auth-Email: <cfuser>' -H 'X-Auth-Key: <cftoken>' 
          https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules/$(/run/current-system/sw/bin/curl -s -X GET -H 'X-Auth-Email: <cfuser>' -H 'X-Auth-Key: <cftoken>' 
          'https://api.cloudflare.com/client/v4/user/firewall/access_rules/rules?mode=block&configuration_target=ip&configuration_value=&page=1&per_page=1' | tr -d '\n' | cut -d'"' -f6)

    [Init]
    cftoken = ${config.sops.placeholder.cloudflare_global_api_key}
    cfuser = ${config.sops.placeholder.cloudflare_username}
  '';

  environment.etc = {
    # Defines a filter that detects URL probing by reading the Nginx access log
    "fail2ban/filter.d/nginx-bruteforce.local".text = pkgs.lib.mkDefault (pkgs.lib.mkAfter ''
      [Definition]
      failregex = ^<HOST>.*(GET /(wp-|admin|boaform|phpmyadmin|\.env|\.git)|\.(dll|so|cfm|asp)|(\?|&)(=PHPB8B5F2A0-3C92-11d3-A3A9-4C7B08C10000|=PHPE9568F36-D428-11d2-A769-00AA001ACF42|=PHPE9568F35-D428-11d2-A769-00AA001ACF42|=PHPE9568F34-D428-11d2-A769-00AA001ACF42)|\\x[0-9a-zA-Z]{2})
    '');

    "fail2ban/action.d/cf.conf".source = config.sops.templates."cloudflare-action.conf".path;
  };
}
