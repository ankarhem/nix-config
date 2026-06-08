{ inputs, ... }:
{
  flake.modules.nixos.blog =
    { pkgs, ... }:
    {
      systemd.tmpfiles.rules = [
        "d /var/www 0755 root root - -"
        "L /var/www/ankarhem.dev - - - - ${inputs.blog.packages.${pkgs.hostPlatform.system}.blog}/public"
      ];

      services.nginx.virtualHosts."ankarhem.dev" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        root = "/var/www/ankarhem.dev";
        locations."/".tryFiles = "$uri $uri/ =404";
        locations."= /404.html".extraConfig = "internal;";
        extraConfig = ''
          error_page 404 /404.html;

          # CSP is served as a response header (not the Zola <meta> tag) so that
          # Cloudflare's JavaScript Detections can parse the per-request nonce and
          # stamp it onto the inline script it injects at the edge. The injected
          # scripts embed a per-request Ray ID + timestamp, so their hash changes
          # on every load and cannot be pinned -- a nonce is the only workable
          # option. Cloudflare stamps this same nonce onto every script it injects
          # (JSD + Web Analytics beacon), so no hash is needed. $request_id is
          # nginx's built-in per-request token (16 bytes of entropy).
          # NOTE: requires the blog's <meta> CSP to be disabled, otherwise it
          # co-enforces without a nonce and re-blocks the injected scripts.
          add_header Content-Security-Policy "default-src 'self'; base-uri 'self'; connect-src 'self' cloudflareinsights.com; form-action 'self'; img-src 'self' data:; script-src 'self' static.cloudflareinsights.com 'nonce-$request_id'; style-src 'self' 'unsafe-inline'" always;
        '';
      };
    };
}
