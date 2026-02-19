---
name: jira-skill
license: GPL-3.0
description: A skill to use when creating or updating branches, commits or github prs in the context of a mentioned jira ticket (e.g. "PROJ-1234") or has a jira ticket in the branch name (such as ORD-2774-map-cart-reference-to-paypal).
---

# Jira Skill

## Prerequisites

- Require GitHub CLI `gh`. Check `gh --version`. If missing, ask the user to install `gh` and stop.
- Require authenticated `gh` session. Run `gh auth status`. If not authenticated, ask the user to run `gh auth login` (and re-run `gh auth status`) before continuing.
- Optional requirement of using atlassian / jira mcp. Used when updating the status of a jira ticket. If not found, the skill will skip updating the ticket status and just print a warning.

## Naming conventions

- Branch: `<PROJ-1234>-{terse-description-in-kebab-case}` max 50–60 chars.
- Commit: `type: {terse description of commit}`. type follows semantic commit types such as `feat`, `fix`, `docs`, etc.
- PR title: `<PROJ-1234> | {description}` summarizing the full diff.

### Creating a Jira ticket

See [CREATE_TICKET.md](references/CREATE_TICKET.md) for details about what to do when asked to create a jira ticket.

### Start working on a jira ticket

See [START_TASK.md](references/START_TASK.md) for details about what to do when asked to start working on a jira ticket.

### Committing

Use the `git-commit` skill when creating commits.

### Creating or updating a Pull Request

See [PULL_REQUEST.md](references/PULL_REQUEST.md).
