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
      nixPkg = config.nix.package;
      truesight = inputs.truesight.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
            command = "${nodejs_lts}/bin/npx";
            args = [
              "-y"
              "@angular/cli"
              "mcp"
            ];
          };
          truesight = {
            type = "stdio";
            command = "${lib.getExe truesight}";
            args = [
              "mcp"
            ];
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
            command = "${nixPkg}/bin/nix";
            args = [
              "run"
              "github:utensils/mcp-nixos"
              "--"
            ];
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
