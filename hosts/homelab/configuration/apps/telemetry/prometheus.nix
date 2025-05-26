{ config, pkgs, ... }:
let
  exporter_ports = {
    node = 9002;
    otel = 8090;
  };
in {

  services.opentelemetry-collector.settings = {
    exporters.prometheus.endpoint = "127.0.0.1:${toString exporter_ports.otel}";
    service.pipelines.metrics.exporters = [ "prometheus" ];
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    retentionTime = "30d";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" "processes" ];
        port = exporter_ports.node;
      };
    };
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs =
          [{ targets = [ "127.0.0.1:${toString exporter_ports.node}" ]; }];
      }
      {
        job_name = "opentelemetry";
        metrics_path = "/metrics";
        scrape_interval = "15s";
        static_configs =
          [{ targets = [ "127.0.0.1:${toString exporter_ports.otel}" ]; }];
      }
    ];
  };
  services.grafana.provision.datasources.settings = {
    datasources = [{
      name = "Promotheus";
      type = "prometheus";
      url = "http://127.0.0.1:${toString config.services.prometheus.port}";
      orgId = 1;
    }];
    deleteDatasources = [{
      name = "Prometheus";
      orgId = 1;
    }];
  };
  services.grafana.provision.dashboards.settings.providers = [{
    name = "Node Exporter Full";
    options.path = pkgs.fetchurl {
      name = "node-exporter-full-37-grafana-dashboard.json";
      url = "https://grafana.com/api/dashboards/1860/revisions/37/download";
      hash = "sha256-1DE1aaanRHHeCOMWDGdOS1wBXxOF84UXAjJzT5Ek6mM=";
    };
    orgId = 1;
  }];
}
