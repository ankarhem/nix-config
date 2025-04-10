{ ... }: {
  imports = [
    ./grafana.nix
    ./prometheus.nix
    ./loki.nix
    ./opentelemetry.nix
    ./tempo.nix
  ];
}
