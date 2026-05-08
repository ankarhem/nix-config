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
      agentBrowserSkills = readSkillsFrom "${inputs.agent-browser}/skills";
      norceSkills = readSkillsFrom "${inputs.norce-agent-instructions}/skills";
      graylogCliSkills = readSkillsFrom "${inputs.graylog-cli}/skills";
    in
    {
      home.packages = [
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.agent-browser
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ck
        pkgs.local.sonarqube-cli
      ];

      home.file.".agents/skills".source =
        let
          skills =
            localSkills
            // (lib.getAttrs [
              "agent-browser"
            ] agentBrowserSkills)
            // (lib.getAttrs [
              "checkout-config"
              "ck"
              "commit"
              "create-pr"
              "git-bisect"
              "jira"
              "using-git-worktrees"
            ] norceSkills)
            // (lib.getAttrs [
              "graylog-cli"
            ] graylogCliSkills)
            // {
              "temporal-developer" = inputs.temporalio-skill;
            };
        in
        pkgs.linkFarm "merged-skills" skills;
    };
}
