# GitHub

When addressing PR review comments, reply on every thread you handle, then resolve it:

- Fixed: "Fixed in <sha>: <what changed>".
- Dismissed: "Not changing this: <why it does not apply>".

Use `gh api graphql` throughout so one thread id (`PRRT_...`) carries from read to resolve:

- List: `pullRequest(number: N) { reviewThreads(first: 100) { nodes { id isResolved isOutdated path line comments(first: 20) { nodes { author { login } body } } } } }`; skip resolved threads.
- Reply: `addPullRequestReviewThreadReply(input: {pullRequestReviewThreadId: $id, body: $body})`.
- Resolve: `resolveReviewThread(input: {threadId: $id})`.

Pass ids and bodies as variables (`-f id=... -f body=...`), never interpolated into the query.
