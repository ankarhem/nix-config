{ pkgs, ... }:
let
  ports = {
    grpc = 4317;
    http = 4318;
  };
in {
  environment.systemPackages = [
    pkgs.bat
    (pkgs.writers.writeBashBin "opentelemetry-show-config" ''
      ${pkgs.bat}/bin/bat $(systemctl cat opentelemetry-collector | grep -oP '(?<=--config=file:)\S+')
    '')
  ];

  networking.firewall.allowedTCPPorts = [ ports.grpc ports.http ];
  services.opentelemetry-collector = {
    enable = true;
    package =
      pkgs.opentelemetry-collector-contrib; # compiled with extra exporters
  };

  services.opentelemetry-collector.settings = {
    receivers = {
      otlp.protocols.grpc.endpoint = "127.0.0.1:${toString ports.grpc}";
      otlp.protocols.http.endpoint = "127.0.0.1:${toString ports.http}";
    };
    service.pipelines.logs.receivers = [ "otlp" ];
    service.pipelines.metrics.receivers = [ "otlp" ];
    service.pipelines.traces.receivers = [ "otlp" ];

    processors = { batch = { }; };
    service.pipelines.logs.processors = [ "batch" ];
    service.pipelines.metrics.processors = [ "batch" ];
    service.pipelines.traces.processors = [ "batch" ];
  };
}
