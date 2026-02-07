{
  self,
  ...
}:
{
  flake.modules.homeManager.mcp =
    { config, pkgs, ... }:
    let
      nodejs_lts = pkgs.nodejs_24;
    in
    {
      sops = {
        secrets = {
          "mcp_tokens.context7" = {
            format = "json";
            sopsFile = "${self}/secrets.json";
          };
          "mcp_tokens.devin" = {
            format = "json";
            sopsFile = "${self}/secrets.json";
          };
          "mcp_tokens.glm" = {
            format = "json";
            sopsFile = "${self}/secrets.json";
          };
          "mcp_tokens.jira" = {
            format = "json";
            sopsFile = "${self}/secrets.json";
          };
        };
      };
      programs.mcp = {
        enable = true;
        servers = {
          playwrite = {
            type = "stdio";
            command = "${nodejs_lts}/bin/npx";
            args = [ "@playwright/mcp@latest" ];
          };
          sequential-thinking = {
            type = "stdio";
            command = "${nodejs_lts}/bin/npx";
            args = [
              "-y"
              "@modelcontextprotocol/server-sequential-thinking"
            ];
          };
          mcp-nixos = {
            type = "stdio";
            command = "nix";
            args = [
              "run"
              "github:utensils/mcp-nixos"
              "--"
            ];
          };
          ms-learn = {
            type = "http";
            url = "https://learn.microsoft.com/api/mcp";
          };
          context7 = {
            type = "http";
            url = "https://mcp.context7.com/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens.context7".path}}";
          };
          atlassian = {
            type = "sse";
            url = "https://mcp.atlassian.com/v1/sse";
          };
          devin-wiki = {
            type = "http";
            url = "https://mcp.devin.ai/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens.devin".path}}";
          };
          zai-websearch = {
            type = "http";
            url = "https://api.z.ai/api/mcp/web_search_prime/mcp";
            headers.Authorization = "Bearer {file:${config.sops.secrets."mcp_tokens.glm".path}}";
          };
          zai-vision = {
            type = "stdio";
            command = "${nodejs_lts}/bin/npx";
            args = [
              "-y"
              "@z_ai/mcp-server"
            ];
            environment = {
              Z_AI_MODE = "ZAI";
              Z_AI_API_KEY = "{file:${config.sops.secrets."mcp_tokens.glm".path}}";
            };
          };
        };
      };
    };
}
