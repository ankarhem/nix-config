---
name: git-bisect
description: Find which commit introduced a bug using git bisect. Use when debugging regressions, finding the root cause of bugs, or when the user wants to identify when a bug was introduced.
allowed-tools: Bash(git:*), Read, Grep, Glob
---

# Git Bisect

Find the commit that introduced a bug using binary search with `git bisect`.

## Prerequisites

Before starting, confirm:

1. **Bug is reproducible** — You can consistently trigger the bug
2. **You know a good commit** — A commit where the bug didn't exist
3. **You know a bad commit** — A commit where the bug exists (usually HEAD)

If no commits have been provided, ask the user to provide them:

> What commit should be use as the **BAD** commit?
>
> 1. HEAD
> 2. User provided commit hash

> What commit should be use as the **GOOD** commit?
>
> 1. HEAD~30
> 2. User provided commit hash

## Workflow

### 1. Create a Test Script

Create a script that explicitly tests for the bug. This script must:

- Return `0` if the bug is NOT present (good state)
- Return `1` if the bug IS present (bad state)
- Return `125` if the commit cannot be tested (e.g., build fails)

Adapt the template to your project's language and test framework:

```bash
#!/bin/bash
set -e

# Build the project (skip commit if build fails)
# Examples:
#   dotnet build || exit 125
#   cargo build || exit 125
<build-command> || exit 125

# Run the test that detects the bug
# Examples:
#   dotnet test --filter "FullyQualifiedName~Namespace.ClassName.TestMethod"
#   cargo test test_name
<test-command> || exit 1

exit 0
```

**Project-specific examples:**

```bash
# .NET
dotnet build || exit 125
dotnet test --filter "FullyQualifiedName~MyApp.Services.PaymentService.ProcessPayment" || exit 1

# Rust
cargo build 2>/dev/null || exit 125
cargo test test_process_payment || exit 1
```

Make the script executable:

```bash
chmod +x bisect-helper.sh
```

### 2. Run Git Bisect

Start the bisect process:

```bash
# Initialize bisect
git bisect start

# Mark the current (bad) commit
git bisect bad <bad-commit>

# Mark a known good commit
git bisect good <good-commit>

# Run automated bisect with the test script
git bisect run ./bisect-helper.sh
```

Git will binary-search through commits, running your test script on each one, until it finds the first bad commit.

### 3. Record the Result

Once bisect identifies the culprit:

```bash
# View the identified commit
git show <culprit-sha>

# Get commit details for reporting
git log -1 --format="%H %s" <culprit-sha>
```

**Clean up:**

```bash
git bisect reset
```

## Output

After finding the regression, provide:

1. **Commit SHA** — Full hash of the culprit commit
2. **Commit message** — The commit's message
3. **Author** — Who made the commit
4. **Date** — When it was committed
5. **Diff** — Show what changed in that commit

Example output format:

```
Regression found!

Commit: abc123def456...
Author: John Doe <john@example.com>
Date:   2024-01-15 10:30:00

Message: Refactor payment processing for performance

Changes:
- Modified payment_service.rb to use async processing
- Removed synchronous fallback that handled edge cases
```

## Tips

- **Narrow the scope** — The fewer commits between good and bad, the faster bisect runs
- **Test script reliability** — Ensure your test is deterministic; flaky tests cause false results
- **Build failures** — Return 125 for commits that can't build so bisect skips them
- **Save the test** — Keep the bisect helper script; it may be useful for future regressions

## NEVER

- **NEVER start bisect without a reliable test** — Manual bisect is error-prone
- **NEVER use `git bisect skip` excessively** — Too many skips defeats binary search efficiency
- **NEVER forget to `git bisect reset`** — Leaves repo in detached HEAD state
