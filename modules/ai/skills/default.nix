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
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      localSkills = readSkillsFrom ./.;
      norceSkills = readSkillsFrom "${inputs.norce-agent-instructions}/skills";
      grafanaCliSkills = readSkillsFrom "${inputs.grafana-cli}/skills";
      graylogCliSkills = readSkillsFrom "${inputs.graylog-cli}/skills";
      ponytailSkills = readSkillsFrom "${inputs.ponytail}/skills";
      impeccableSkills = readSkillsFrom "${inputs.impeccable-skill}/.opencode/skills";

      llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      agentBrowser = llm-agents.agent-browser;
      hunk = llm-agents.hunk;

      # Used by the pico-images skill. The guest-link id is the only credential
      # on an otherwise unauthenticated upload endpoint, so it lives in sops
      # (picoshare/guest_link) instead of the skill text.
      picoUpload = pkgs.writeShellApplication {
        name = "pico-upload";
        runtimeInputs = [
          pkgs.curl
          pkgs.jq
        ];
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "usage: pico-upload <file> [file ...]" >&2
            exit 2
          fi

          guest_link=$(cat ${config.sops.secrets."picoshare/guest_link".path})

          for file in "$@"; do
            entry_id=$(curl -sS -X POST -H 'Accept: application/json' \
              -F "file=@''${file}" \
              "https://pico.ankarhem.dev/api/guest/''${guest_link}" | jq -r '.id')
            echo "https://pico.ankarhem.dev/-''${entry_id}"
          done
        '';
      };
    in
    {
      sops.secrets."picoshare/guest_link" = { };

      home.packages = [
        agentBrowser
        hunk
        pkgs.local.sonarqube-cli
        picoUpload
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
              "commit"
              "create-pr"
              "git-bisect"
              "jira"
            ] norceSkills)
            // (lib.getAttrs [
              "gcli"
            ] grafanaCliSkills)
            // (lib.getAttrs [
              "graylog-cli"
            ] graylogCliSkills)
            // {
              "temporal-developer" = inputs.temporalio-skill;
              "agent-browser" = (readSkillsFrom "${agentBrowser}/share/agent-browser/skills").agent-browser;
              "hunk" = (readSkillsFrom "${hunk}/share/hunk/skills").hunk-review;
              "rust-skill" = inputs.rust-skill;
            };
        in
        pkgs.linkFarm "merged-skills" skills;
    };
}
