# Start working on a Jira ticket

Check the default branch `git symbolic-ref --short refs/remotes/origin/HEAD`. This will output something like `origin/main` or `origin/master`.

Check if you're currently checked out in the correct branch (will include the ticket such as PROJ-1234). If not checkout out in the default branch, checkout the default branch and make sure it is updated. `git checkout {default_branch} && git pull`. If there are any unstaged changes, ask the user to either stash or commit them before switching branches and immediately exit.

Look up the jira ticket using the atlassian / jira mcp. If not found, print a warning and exit.

Check if there is already a branch for the ticket and if found ask the user if they want to checkout the branch and exit.

```bash
git branch --list "*<PROJ-1234>*"
git ls-remote --heads origin "*<PROJ-1234>*"
```

Otherwise create the branch `git checkout -b <PROJ-1234>-{terse-description-in-kebab-case}`.
