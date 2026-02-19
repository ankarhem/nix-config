# Creating or updating a Pull Request

If there are any unstaged changes, start by applying the commit logic (use `git-commit` skill) and then push the branch to the remote `git push`.
If it errors due to an upstream branch not being set, warn the user and exit.

If the jira mcp is available:

- Include a link to the jira ticket at the end of the pull request description.

#### Creating a pull request

Use the `gh` cli to create a pull request with the naming convention. `gh pr create --title "<PROJ-1234> | {description}" --body "{full description}"`.

If the jira mcp is available:

- Update the status of the jira ticket to "In Review".
- Update the ticket description with a more detailed description. If it is a feature, include the motivation and the implementation details. If it is a bug, include a more detailed explanation of why it happened.

#### Updating a pull request

Use the `gh` cli to update the pull request body with `gh pr edit --body "{full description}"`.

If the jira mcp is available:

- Update the ticket description with a detailed description. If it is a feature, include the motivation and the implementation details. If it is a bug, include a more detailed explanation of why it happened.
