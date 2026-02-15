{ pkgs }:
pkgs.writeShellApplication {
  name = "clone_org";
  runtimeInputs = [ pkgs.gh ];
  text = ''

    # Check if organization name is provided
    if [ $# -eq 0 ]; then
      echo "Usage: $0 <organization_name>"
      exit 1
    fi

    ORG_NAME="$1"
    FOLDER_NAME="$ORG_NAME"

    # Create a folder for organization
    mkdir -p "$FOLDER_NAME"
    cd "$FOLDER_NAME" || exit

    # Fetch and clone all repositories in organization
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

    echo "All repositories from $ORG_NAME have been processed. Check '$FOLDER_NAME' folder."

  '';
}
