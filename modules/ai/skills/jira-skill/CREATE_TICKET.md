# Creating a Jira ticket

If the jira mcp is not available, warn the user and exit.

To create a jira ticket you will need the following information:

- What is the project key? (e.g. PROJ)
- What is the issue type? (e.g. Task, Bug, Story, etc.)
- What is the title of the issue? (a one line description)
- What is the description of the issue? (a more detailed description of the issue, including motivation and any relevant details)
- What is the `component` of the issue? (optional, but can be helpful for categorizing the issue)

You can extrapolate the issue type, title and description from the conversation, but if you are not sure, ask the user for clarification.

If a project key is not mentioned, ask the user for the project key and provide a list of available projects from the jira mcp.

The `component` field is most likely the repo that you are currently in. If it's not obvious if that is the case just skip this field.
