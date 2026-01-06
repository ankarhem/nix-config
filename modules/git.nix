{ lib, config, ... }:
{
  imports = [
    config.flake.modules.homeManager.gh
  ];

  flake.modules.homeManager.git =
    { pkgs, ... }:
    let
      clone_org = pkgs.writeShellApplication {
        name = "clone_org";
        runtimeInputs = [ pkgs.gh ];
        text = ''
          #!/bin/bash

          # Check if the organization name is provided
          if [ $# -eq 0 ]; then
            echo "Usage: $0 <organization_name>"
            exit 1
          fi

          ORG_NAME="$1"
          FOLDER_NAME="$ORG_NAME"

          # Create a folder for the organization
          mkdir -p "$FOLDER_NAME"
          cd "$FOLDER_NAME" || exit

          # Fetch and clone all repositories in the organization
          echo "Cloning all repositories from organization: $ORG_NAME"
          gh repo list "$ORG_NAME" --limit 1000 | while read -r repo _; do
            REPO_NAME=$(basename "$repo")
            if [ -d "$REPO_NAME" ]; then
              echo "Repository $REPO_NAME already exists. Skipping..."
            else
              echo "Cloning $repo..."
              gh repo clone "$repo"
            fi
          done

          echo "All repositories from $ORG_NAME have been processed. Check the '$FOLDER_NAME' folder."
        '';
      };
      getGithubKeys =
        { username, sha256 }:
        let
          authorizedKeysFile = builtins.fetchurl {
            url = "https://github.com/${username}.keys";
            inherit sha256;
          };
          keys = pkgs.lib.splitString "\n" (builtins.readFile authorizedKeysFile);
        in
        builtins.filter (s: s != "") keys;
    in
    {
      home.file.".config/git/allowed_signers".text =
        let
          authorizedKeys = helpers.ssh.getGithubKeys {
            username = "ankarhem";
            sha256 = "1i0zyn1jbndfi8hqwwhmbn3b6akbibxkjlwrrg7w2988gs9c96gi";
          };
          allowedSigners = builtins.concatStringsSep "\n" (builtins.map (key: "* ${key}") authorizedKeys);
        in
        allowedSigners;

      programs.git = {
        enable = true;

        signing = {
          signByDefault = true;
          key = lib.mkDefault "0x529972E4160200DF";
        };

        settings = {
          user = {
            name = "Jakob Ankarhem";
            email = "jakob@ankarhem.dev";
          };
          init.defaultBranch = "main";
          # Configure Git to ensure line endings in files you checkout are correct for macOS
          core.autocrlf = "input";

          merge.tool = "nvimdiff2";
          mergetool.hideResolved = true;
          mergetool.keepBackup = false;

          # Default to git pull --rebase
          pull.rebase = true;
          # Automatically --set-upstream if not set
          push.autoSetupRemote = true;

          diff.external = "${pkgs.difftastic}/bin/difft";
        };
      };

      home.programs = [ clone_org ];
    };
}
