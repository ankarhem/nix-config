{ config, pkgs, ... }: {
  imports = [ ./livekit.nix ./lk-jwt-service.nix ];

  services.nginx.virtualHosts."call.internetfeno.men" = {
    useACMEHost = "internetfeno.men";
    forceSSL = true;
    root = pkgs.element-call;
    locations."/".extraConfig = ''
      try_files $uri /$uri /index.html;
      add_header Cache-Control "public, max-age=30, stale-while-revalidate=30";
    '';
    # assets can be cached because they have hashed filenames
    locations."/assets".extraConfig = ''
      add_header Cache-Control "public, immutable, max-age=31536000";
    '';
    locations."/config.json".extraConfig = ''
      default_type application/json;
      return 200 '${
        builtins.toJSON {
          default_server_config = {
            "m.homeserver" = {
              "base_url" =
                "https://${config.services.matrix-synapse.settings.public_baseurl}";
              "server_name" =
                config.services.matrix-synapse.settings.server_name;
            };
          };
          livekit.livekit_service_url = "https://livekit-jwt.internetfeno.men";
        }
      }';
    '';
  };

  services.matrix-synapse.settings = {
    # The maximum allowed duration by which sent events can be delayed, as
    # per MSC4140.
    max_event_delay_duration = "24h";

    rc_message = {
      # This needs to match at least e2ee key sharing frequency plus a bit of headroom
      # Note key sharing events are bursty
      per_second = 0.5;
      burst_count = 30;
    };

    # This needs to match at least the heart-beat frequency plus a bit of headroom
    # Currently the heart-beat is every 5 seconds which translates into a rate of 0.2s
    rc_delayed_event_mgmt = {
      per_second = 1;
      burst_count = 20;
    };
  };
}
