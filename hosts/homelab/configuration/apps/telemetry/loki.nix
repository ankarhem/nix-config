{ config, ... }:
{
  services.opentelemetry-collector.settings = {
    exporters."otlphttp/loki".endpoint =
      "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/otlp";
    service.pipelines.logs.exporters = [ "otlphttp/loki" ];
  };

  # https://git.ingolf-wagner.de/palo/nixos-config/src/branch/main/machines/chungus/telemetry/loki.nix
  services.loki = {
    enable = true;
    # https://grafana.com/docs/loki/latest/configure/#supported-contents-and-default-values-of-lokiyaml
    configuration = {

      server = {
        http_listen_port = 3100;
        log_level = "warn";
      };
      auth_enabled = false;

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore = {
              store = "inmemory";
            };
            replication_factor = 1;
          };
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 999999;
        chunk_retain_period = "30s";
      };

      schema_config = {
        configs = [
          {
            from = "2024-05-28";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-shipper-active";
          cache_location = "/var/lib/loki/tsdb-shipper-cache";
          cache_ttl = "24h";
        };

        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        allow_structured_metadata = true;
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        compactor_ring = {
          kvstore = {
            store = "inmemory";
          };
        };
      };

      # The query_range block configures the query splitting and caching in the Loki query-frontend.
      query_range = {
        # Perform query parallelisations based on storage sharding configuration and
        # query ASTs. This feature is supported only by the chunks storage engine.
        parallelise_shardable_queries = false; # false because of https://github.com/grafana/loki/issues/7649#issuecomment-1625645403
      };
    };
  };

  # https://grafana.com/docs/grafana/latest/datasources/loki/#provision-the-loki-data-source
  services.grafana.provision.datasources.settings = {
    datasources = [
      {
        name = "Loki";
        type = "loki";
        url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}";
        orgId = 1;
        jsonData = {
          timeout = 360;
          maxLines = 1000;
        };
      }
    ];
    deleteDatasources = [
      {
        name = "Loki";
        orgId = 1;
      }
    ];
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 3031;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          url = "http://127.0.0.1:${toString config.services.loki.configuration.server.http_listen_port}/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "systemd-journal";
              host = "${config.networking.hostName}";
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
