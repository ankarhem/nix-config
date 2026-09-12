{ ... }:
let
  domain = "n8n.ankarhem.dev";
  sandboxVersion = "1.3.4";
in
{
  flake.modules.nixos.n8n =
    { config, pkgs, ... }:
    {
      sops.secrets = {
        "n8n/encryption_key" = { };
        "n8n/sandbox_api_key" = { };
        "n8n/sandbox_runner_key" = { };
        "n8n/sandbox_reg_token" = { };
      };

      sops.templates."sandbox-api.env".content = ''
        SANDBOX_API_KEYS=${config.sops.placeholder."n8n/sandbox_api_key"}
        SANDBOX_API_RUNNER_REGISTRATION_TOKEN=${config.sops.placeholder."n8n/sandbox_reg_token"}
        SANDBOX_API_RUNNER_API_KEY=${config.sops.placeholder."n8n/sandbox_runner_key"}
      '';
      sops.templates."sandbox-runner.env".content = ''
        SANDBOX_RUNNER_API_KEYS=${config.sops.placeholder."n8n/sandbox_runner_key"}
        SANDBOX_RUNNER_REGISTRATION_TOKEN=${config.sops.placeholder."n8n/sandbox_reg_token"}
      '';

      services.n8n = {
        enable = true;
        environment = {
          N8N_HOST = domain;
          N8N_PORT = 5678;
          N8N_PROTOCOL = "https";
          N8N_LISTEN_ADDRESS = "127.0.0.1";
          N8N_PROXY_HOPS = 1;
          N8N_WEBHOOK_URL = "https://${domain}";
          N8N_ENCRYPTION_KEY_FILE = config.sops.secrets."n8n/encryption_key".path;
          # n8n Assistant (instance-ai) with Z.AI GLM over its
          # OpenAI-compatible endpoint; key reused from open-webui.
          N8N_ENABLED_MODULES = "instance-ai";
          N8N_INSTANCE_AI_MODEL = "openai/glm-5.3";
          N8N_INSTANCE_AI_MODEL_URL = "https://api.z.ai/api/coding/paas/v4";
          N8N_INSTANCE_AI_MODEL_API_KEY_FILE = config.sops.secrets."mcp_tokens/glm".path;
          N8N_INSTANCE_AI_SANDBOX_ENABLED = true;
          N8N_INSTANCE_AI_SANDBOX_PROVIDER = "n8n-sandbox";
          N8N_SANDBOX_SERVICE_URL = "http://127.0.0.1:8080";
          N8N_SANDBOX_SERVICE_API_KEY_FILE = config.sops.secrets."n8n/sandbox_api_key".path;
        };
      };

      services.nginx.virtualHosts."${domain}" = {
        forceSSL = true;
        useACMEHost = "ankarhem.dev";
        extraConfig = ''
          client_max_body_size 50M;
          proxy_read_timeout 300s;
          proxy_connect_timeout 75s;
        '';
        locations."/" = {
          proxyWebsockets = true;
          proxyPass = "http://${config.services.n8n.environment.N8N_LISTEN_ADDRESS}:${toString config.services.n8n.environment.N8N_PORT}";
        };
      };

      # Self-hosted Assistant code sandbox (n8n-sandbox API + one
      # privileged Docker-in-Docker runner, mTLS between them).
      # One-time setup on the host before first deploy:
      #   - LXC needs nesting for privileged DinD (pct set <CTID> --features nesting=1)
      #   - bootstrap TLS: bootstrap-mtls.sh -o /var/lib/n8n-sandbox/tls -n 1 \
      #       --api-san sandbox-api --control-sans "sandbox-runner-1,localhost"
      systemd.services.docker-network-n8n-sandbox = {
        description = "Ensure n8n-sandbox docker network exists";
        after = [ "docker.service" ];
        wants = [ "docker.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${pkgs.docker}/bin/docker network inspect n8n-sandbox >/dev/null 2>&1 || \
            ${pkgs.docker}/bin/docker network create n8n-sandbox
        '';
      };

      virtualisation.oci-containers.containers = {
        sandbox-api = {
          image = "n8nio/n8n-sandbox-service-api:${sandboxVersion}";
          ports = [ "127.0.0.1:8080:8080" ];
          volumes = [ "/var/lib/n8n-sandbox/tls/api:/grpc-tls:ro" ];
          environment = {
            SANDBOX_API_GRPC_TLS_CERT_FILE = "/grpc-tls/grpc-server.crt";
            SANDBOX_API_GRPC_TLS_KEY_FILE = "/grpc-tls/grpc-server.key";
            SANDBOX_API_GRPC_TLS_CLIENT_CA_FILE = "/grpc-tls/ca.crt";
            SANDBOX_API_RUNNER_CONTROL_GRPC_TLS_CA_FILE = "/grpc-tls/ca.crt";
            SANDBOX_API_RUNNER_CONTROL_GRPC_TLS_CERT_FILE = "/grpc-tls/control-grpc-api-client.crt";
            SANDBOX_API_RUNNER_CONTROL_GRPC_TLS_KEY_FILE = "/grpc-tls/control-grpc-api-client.key";
            SANDBOX_API_ENABLE_CORS = "true";
          };
          environmentFiles = [ config.sops.templates."sandbox-api.env".path ];
          extraOptions = [ "--network=n8n-sandbox" ];
        };
        sandbox-runner-1 = {
          image = "n8nio/n8n-sandbox-service-runner-dind:${sandboxVersion}";
          volumes = [ "/var/lib/n8n-sandbox/tls/runner:/grpc-tls:ro" ];
          environment = {
            SANDBOX_RUNNER_DOCKER_SANDBOX_IMAGE = "n8nio/n8n-sandbox-service-sandbox:${sandboxVersion}";
            SANDBOX_RUNNER_API_GRPC_ADDR = "sandbox-api:9090";
            SANDBOX_RUNNER_HTTP_BASE_URL = "https://sandbox-runner-1:8080";
            SANDBOX_RUNNER_CONTROL_GRPC_LISTEN_ADDR = ":9091";
            SANDBOX_RUNNER_CONTROL_GRPC_ADVERTISE_ADDR = "sandbox-runner-1:9091";
            SANDBOX_RUNNER_ID = "homelab-runner-1";
            SANDBOX_RUNNER_REGISTRATION_GRPC_CA_FILE = "/grpc-tls/ca.crt";
            SANDBOX_RUNNER_REGISTRATION_GRPC_CERT_FILE = "/grpc-tls/grpc-client.crt";
            SANDBOX_RUNNER_REGISTRATION_GRPC_KEY_FILE = "/grpc-tls/grpc-client.key";
            SANDBOX_RUNNER_REGISTRATION_GRPC_SERVER_NAME = "sandbox-api";
            SANDBOX_RUNNER_CONTROL_GRPC_TLS_CERT_FILE = "/grpc-tls/control-grpc-server.crt";
            SANDBOX_RUNNER_CONTROL_GRPC_TLS_KEY_FILE = "/grpc-tls/control-grpc-server.key";
            SANDBOX_RUNNER_CONTROL_GRPC_TLS_CLIENT_CA_FILE = "/grpc-tls/ca.crt";
          };
          environmentFiles = [ config.sops.templates."sandbox-runner.env".path ];
          extraOptions = [
            "--privileged"
            "--network=n8n-sandbox"
          ];
        };
      };

      systemd.services.docker-sandbox-api = {
        after = [ "docker-network-n8n-sandbox.service" ];
        wants = [ "docker-network-n8n-sandbox.service" ];
      };
      systemd.services.docker-sandbox-runner-1 = {
        after = [
          "docker-network-n8n-sandbox.service"
          "docker-sandbox-api.service"
        ];
        wants = [
          "docker-network-n8n-sandbox.service"
          "docker-sandbox-api.service"
        ];
      };
      systemd.services.n8n = {
        after = [ "docker-sandbox-api.service" ];
        wants = [ "docker-sandbox-api.service" ];
      };
    };
}
