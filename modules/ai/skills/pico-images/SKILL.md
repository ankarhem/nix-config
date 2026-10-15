---
name: pico-images
description: Use when a PR, issue or comment needs screenshots or other images embedded. Hosts them on the user's PicoShare instance (pico.ankarhem.dev) because GitHub cannot take binary attachments through gh/its API, and private-repo images must be fetchable by GitHub's proxy. Covers upload, the raw image URL and markdown embedding.
---

# Images for PRs and issues (PicoShare)

`gh gist create` refuses binaries and the GitHub API cannot attach images to a PR body, so images must already be hosted somewhere. Use the user's PicoShare instance.

## Upload

```bash
pico-upload /tmp/shot.png      # prints one line per file: https://pico.ankarhem.dev/-<entry-id>
```

## Embed

```text
https://pico.ankarhem.dev/-<entry-id>              # raw bytes (image/png)
https://pico.ankarhem.dev/-<entry-id>/<filename>   # verbose form, same bytes
```

```markdown
![transactions page](https://pico.ankarhem.dev/-kT8yWksebo)
```

Verify before putting it in the PR (status + content type + size must match the local file):

```bash
curl -sS -o /dev/null -w '%{http_code} %{content_type} %{size_download}\n' \
  'https://pico.ankarhem.dev/-<entry-id>'
```

## Notes

- `/<id>`, `/raw/<id>` and `/files/<id>` are 404 on this instance; `/-<id>` is the URL that serves the file.
- Entry links are unlisted but unauthenticated: anyone with the URL can fetch the image.
- Reference the images from the PR body (`gh pr create --body-file`) rather than committing them to the repo.
