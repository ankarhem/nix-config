{ inputs, ... }:
{
  flake.modules.homeManager.claude =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      transformedMcpServers = lib.optionalAttrs (config.programs.mcp.enable) (
        lib.mapAttrs (
          name: server:
          (removeAttrs server [ "disabled" ])
          // (lib.optionalAttrs (server ? url) { type = "http"; })
          // (lib.optionalAttrs (server ? command) { type = "stdio"; })
          // {
            enabled = !(server.disabled or false);
          }
        ) config.programs.mcp.servers
      );
    in

    {
      programs.claude-code = {
        enable = true;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;

        settings = {
          alwaysThinkingEnabled = true;
          env = {
            API_TIMEOUT_MS = "3000000";
          };
          enabledPlugins = lib.genAttrs [
            "commit-commands@claude-plugins-official"
            "csharp-lsp@claude-plugins-official"
            "ralph-wiggum@claude-plugins-official" # This is not it; https://www.youtube.com/watch?v=O2bBWDoxO4s
            "rust-analyzer-lsp@claude-plugins-official"
            "typescript-lsp@claude-plugins-official"
          ] (_: true);
        };
        mcpServers = transformedMcpServers;
      };
    };
}
