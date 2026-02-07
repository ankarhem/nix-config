{
  flake.modules.homeManager.claude =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.happy-coder
      ];

      programs.claude-code = {
        enable = true;

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
        mcpServers = lib.mkIf config.programs.mcp.enable config.programs.mcp.servers;
      };
    };
}
