{
  inputs,
  self,
  ...
}:
{
  flake.modules.homeManager.mcp =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      nodejs_lts = pkgs.nodejs_24;
      npx = lib.getExe' nodejs_lts "npx";
      uvx = lib.getExe' pkgs.uv "uvx";
    in
    {
      sops = {
        secrets = {
          "mcp_tokens/context7" = {
          };
          "mcp_tokens/devin" = {
          };
          "mcp_tokens/glm" = {
          };
        };
      };
      programs.mcp = {
        enable = true;
        servers = {
          angular = {
            type = "stdio";
            command = npx;
            args = [
              "-y"
              "@angular/cli"
              "mcp"
            ];
          };
          sequential-thinking = {
            type = "stdio";
            command = npx;
            args = [
              "-y"
              "@modelcontextprotocol/server-sequential-thinking"
            ];
          };
          mcp-nixos = {
            type = "stdio";
            command = uvx;
            args = [ "mcp-nixos" ];
          };
          context7 = {
            type = "http";
            url = "https://mcp.context7.com/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens/context7".path}}";
          };
          devin-wiki = {
            type = "http";
            url = "https://mcp.devin.ai/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens/devin".path}}";
          };
          zai-websearch = {
            type = "http";
            url = "https://api.z.ai/api/mcp/web_search_prime/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens/glm".path}}";
          };
        };
      };
    };
}
