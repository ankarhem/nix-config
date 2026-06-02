{
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.hermes-agent.nixosModules.default
  ];

  # Reuse the existing z.ai / GLM key (already in secrets.yaml, also used by
  # open-webui and the MCP tooling) and render it as the env var the hermes
  # `zai` provider reads.
  sops.secrets."mcp_tokens/glm" = { };
  sops.templates."hermes.env".content = ''
    GLM_API_KEY=${config.sops.placeholder."mcp_tokens/glm"}
  '';

  services.hermes-agent = {
    enable = true;

    # Native, hardened systemd service (NoNewPrivileges, ProtectSystem=strict,
    # PrivateTmp). The agent cannot self-install packages and only sees tools on
    # the Nix-provided PATH. To allow runtime package installs in an isolated
    # Ubuntu container instead, set `container.enable = true` (sandboxed, but
    # mutable). Native mode is the more locked-down option for a first deploy.

    settings = {
      # z.ai / GLM. The explicit provider form is required here: a configured
      # `model.base_url` is only honored when `model.provider` matches the
      # resolved provider, so the slug form ("zai/glm-5.1") would silently
      # ignore base_url and fall back to the general endpoint. We pin the
      # Coding Plan endpoint, which is what the GLM key is scoped to.
      model = {
        provider = "zai";
        default = "glm-5.1";
        base_url = "https://api.z.ai/api/coding/paas/v4";
      };

      # Full tool access (web search, terminal, file editing, memory,
      # delegation, etc.). NOTE: "all" includes the terminal toolset, so the
      # agent can run shell commands as the `hermes` user on the host (in native
      # mode, constrained only by the systemd hardening above). Switch to
      # `container.enable = true` if you want shell execution sandboxed.
      toolsets = [ "all" ];

      # Max agent turns (one LLM call + its tool executions) per task before the
      # agent stops. `agent.max_turns` is the authoritative key (a top-level
      # `max_turns` is migrated into it at load time).
      agent.max_turns = 100;

      # Per-command timeout in seconds for the terminal toolset (kills any
      # single shell command that runs longer than this).
      terminal = {
        backend = "local";
        timeout = 180;
      };
    };

    environmentFiles = [ config.sops.templates."hermes.env".path ];

    # Put the `hermes` CLI on the system PATH and share state with the gateway.
    addToSystemPackages = true;
  };
}
