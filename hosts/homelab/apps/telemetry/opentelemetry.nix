{ pkgs, pkgs-unstable, ...}:{
  environment.systemPackages = [
    pkgs.bat
    (pkgs.writers.writeBashBin "opentelemetry-show-config" ''
      ${pkgs.bat}/bin/bat $(systemctl cat opentelemetry-collector | grep -oP '(?<=--config=file:)\S+')
    '')
  ];

  services.opentelemetry-collector = {
    enable = true;
    package = pkgs-unstable.opentelemetry-collector-contrib; # compiled with extra exporters
  };

  services.opentelemetry-collector.settings = {
    receivers = {
      otlp.protocols.grpc.endpoint = "127.0.0.1:4317";
      otlp.protocols.http.endpoint = "127.0.0.1:4318";
    };
    
    service.pipelines.logs.receivers = [ "otlp" ];
    service.pipelines.metrics.receivers = [ "otlp" ];
    service.pipelines.traces.receivers = [ "otlp" ];
  };
}
