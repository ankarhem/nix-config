{
  lib,
  inputs,
  self,
  ...
}:
let
  readSkillsFrom =
    dir:
    builtins.mapAttrs (name: _: dir + "/${name}") (
      lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir)
    );
in
{
  flake.modules.homeManager.skills =
    { lib, pkgs, ... }:
    let
      localSkills = readSkillsFrom ./.;
      agentBrowser = pkgs.fetchFromGitHub {
        owner = "vercel-labs";
        repo = "agent-browser";
        rev = "a95bc0f75a45560f953594b155cc1ff57f1a0170";
        hash = "sha256-8WWq9HJVIEb7C+pr6OYv8+2LbvCMFQSnDzUmy6lNptg=";
      };
      agentBrowserSkills = readSkillsFrom "${agentBrowser}/skills";
    in
    {
      home.packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ck
      ];

      home.file.".agents/skills".source =
        let
          skills =
            localSkills
            // lib.getAttrs [
              "agent-browser"
              "dogfood"
            ] agentBrowserSkills;
        in
        pkgs.linkFarm "merged-skills" skills;
    };
}
