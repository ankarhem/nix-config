---
name: create-pr
description: Creates GitHub pull requests with properly formatted titles. Use when creating PRs, submitting changes for review, or when the user says /pr or asks to create a pull request.
allowed-tools: Bash(git:*), Bash(gh:*), Read, Grep, Glob
---

# Create Pull Request

Creates GitHub PRs with conventional commit-style titles.

## Prerequisites

Check if `gh` cli is available, otherwise guide user to install it:

```bash
gh --version

# https://cli.github.com/
# (don't install it without user approval)
# macos: brew install gh
```

## PR Title Format

```
# With Jira ticket (if ticket ID found in branch name):
TICKET-1234 | <type>(<scope>): <summary>

# Standard format (if no ticket ID found):
<type>(<scope>): <summary>
```

### Types (required)

| Type       | Description                         |
| ---------- | ----------------------------------- |
| `feat`     | New feature                         |
| `fix`      | Bug fix                             |
| `perf`     | Performance improvement             |
| `test`     | Adding/correcting tests             |
| `docs`     | Documentation only                  |
| `refactor` | Code change (no bug fix or feature) |
| `build`    | Build system or dependencies        |
| `ci`       | CI configuration                    |
| `chore`    | Routine tasks, maintenance          |

### Scopes (optional but recommended)

Use scopes that make sense for the project (e.g., package names, component names, feature areas)

### Summary Rules

- Use imperative present tense: "Add" not "Added"
- Capitalize first letter
- No period at the end
- No ticket IDs in summary (use prefix instead)

## Steps

1. **Check current state**:

```bash
git status
git diff --stat
git log origin/main..HEAD --oneline
```

- If the worktree is not clean, load the `commit` skill.
- Push branch if needed.

2. **Extract ticket references (if not obvious from the context)**:

```bash
# Check branch name for Jira ticket (e.g., TICKET-1234, ABC-123)
git branch --show-current

# Check commit messages for ticket IDs or GitHub issue numbers (#123)
git log origin/main..HEAD --format=%s
```

3. **Analyze changes to determine**:

- Jira ticket: Extract from branch name or commits (e.g., TICKET-1234)
- GitHub issues: Note any #123 references
- Type: What kind of change is this?
- Scope: Which package/area is affected?
- Summary: What does the change do?

4. **If PR type is `fix` (bug fix), prompt user for regression analysis**:

Ask the user:

> "This is a bug fix PR. Would you like me to find which commit introduced the regression?"
>
> Options:
>
> 1. **Yes, using git bisect** — Load the `git-bisect` skill to automatically find the regression commit
> 2. **Find likely culprit using git log** — I'll analyze recent commits to identify the most probable cause
> 3. **No** — Skip regression analysis

### Option 1: Git Bisect

Load the `git-bisect` skill and follow its workflow to find the regression commit.

### Option 2: Git Log Analysis

Analyze recent commits to find likely culprits:

```bash
# Show recent commits in affected files/areas
git log --oneline -20 -- <scope-path>

# Look for commits mentioning relevant keywords
git log --oneline --grep="bug\|fix\|issue\|<scope>" -20

# Show commits that touched specific files
git log -p --oneline -10 -- <affected-files>
```

Based on commit messages and changes, identify the most likely regression commit.

### After Finding the Regression Commit

Once the regression commit is identified (via either method):

- **Add comment to Jira ticket** (if ticket exists):

Load the `jira` skill and follow the instructions to add a comment:

> Bug introduced in [hash](link-to-commit).

- **Include in PR body** under a new "Regression" section:

```markdown
## Regression

This bug was introduced in [<sha>](commit-url): <commit message>
```

5. **Create PR with appropriate title format and body**:

```bash
# If Jira ticket found (e.g., TICKET-1234):
# TICKET-1234 | <type>(<scope>): <summary>

# Otherwise:
# <type>(<scope>): <summary>

gh pr create --draft --title "$TITLE" --body "$(cat <<'EOF'
## Summary

<Describe what the PR does and how to test>

## Related Issues

<!-- Jira ticket (if applicable): -->
<!-- [TICKET-1234](https://norce.atlassian.net/browse/TICKET-1234) -->

<!-- GitHub issues (use keywords to auto-close): -->
<!-- closes #123, resolves #456 -->
EOF
)"
```

## PR Body Guidelines

### Summary Section

- Describe what the PR does
- Explain how to test the changes

### Related Issues Section

- Jira ticket: [TICKET-1234](https://norce.atlassian.net/browse/TICKET-1234)
  - Domain may vary based on organization - infer from context

- GitHub issues: Use keywords to auto-close
  - closes #123 - closes issue when PR is merged
  - fixes #456 - closes issue when PR is merged
  - resolves #789 - closes issue when PR is merged

## Examples

### With Jira Ticket

```
ABC-1234 | feat(api): Add user authentication endpoint
```

### Feature with scope

```
feat(editor): Add workflow performance metrics display
```

### Bug fix with GitHub issue reference

```
fix(core): Resolve memory leak in execution engine

closes #456
```

### Breaking change (add exclamation mark before colon)

```
feat(api)!: Remove deprecated v1 endpoints
```

### No scope (affects multiple areas)

```
chore: Update dependencies to latest versions
```
