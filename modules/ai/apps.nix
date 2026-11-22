{ inputs, ... }:
{
  flake.modules.homeManager.ai-apps =
    { lib, pkgs, ... }:
    {
      home.packages = lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr-app
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
      ];
    };
}
