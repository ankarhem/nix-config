{ config, ... }:
let
  otlp_ports = {
    grpc = 14317;
    http = 14318;
  };
in {
  services.opentelemetry-collector.settings = {
    exporters."otlphttp/tempo".endpoint =
      "http://127.0.0.1:${toString otlp_ports.http}";
    service.pipelines.traces.exporters = [ "otlphttp/tempo" ];
  };
  services.tempo = {
    enable = true;
    settings = {
      server = {
        http_listen_port = 3200;
        grpc_listen_port = 3201;
      };
      distributor = {
        receivers = {
          otlp = {
            protocols = {
              http = { endpoint = "127.0.0.1:${toString otlp_ports.http}"; };
              grpc = { endpoint = "127.0.0.1:${toString otlp_ports.grpc}"; };
            };
          };
        };
      };
      storage.trace = {
        backend = "local";
        local.path = "/var/lib/tempo/traces";
        wal.path = "/var/lib/tempo/wal";
      };
      ingester = { lifecycler.address = "127.0.0.1"; };
    };
  };
  services.grafana.provision.datasources.settings = {
    datasources = [{
      name = "Tempo";
      type = "tempo";
      url = "http://127.0.0.1:${
          toString config.services.tempo.settings.server.http_listen_port
        }";
      orgId = 1;
    }];
    deleteDatasources = [{
      name = "Tempo";
      orgId = 1;
    }];
  };
}
