{
  lib,
  inputs,
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
      norceSkills = readSkillsFrom "${inputs.norce-agent-instructions}/skills";
      graylogCliSkills = readSkillsFrom "${inputs.graylog-cli}/skills";
      ponytailSkills = readSkillsFrom "${inputs.ponytail}/skills";
      impeccableSkills = readSkillsFrom "${inputs.impeccable-skill}/.opencode/skills";

      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      agentBrowser = llm-agents.agent-browser;
      hunk = llm-agents.hunk;
    in
    {
      home.packages = [
        agentBrowser
        hunk
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ck
        pkgs.local.sonarqube-cli
      ];

      home.file.".agents/skills".source =
        let
          skills =
            localSkills
            // ponytailSkills
            // impeccableSkills
            // (lib.getAttrs [
              "argue"
              "checkout-domain"
              "checkout-config"
              "ck"
              "commit"
              "create-pr"
              "git-bisect"
              "jira"
            ] norceSkills)
            // (lib.getAttrs [
              "graylog-cli"
            ] graylogCliSkills)
            // {
              "temporal-developer" = inputs.temporalio-skill;
              "agent-browser" = (readSkillsFrom "${agentBrowser}/share/agent-browser/skills").agent-browser;
              "hunk" = (readSkillsFrom "${hunk}/skills").hunk-review;
              "rust-skill" = inputs.rust-skill;
            };
        in
        pkgs.linkFarm "merged-skills" skills;
    };
}
