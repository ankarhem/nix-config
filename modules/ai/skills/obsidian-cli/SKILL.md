---
name: obsidian-cli
description: Use when the user wants to read, write, search, or manage their Obsidian vault from the terminal — notes, daily notes, tasks, search, properties, tags, links. Uses the official Obsidian CLI (IPC to the running Obsidian app; vault "obsidian-vault"). Skip for conceptual Obsidian questions or GUI/plugin how-tos.
---

# Obsidian CLI

Official CLI (Obsidian v1.12+). Talks to the **running** Obsidian desktop app via IPC — if Obsidian isn't running, commands hang or return empty. Single vault: `obsidian-vault`.

## Access policy

`Agents/` is the shared agent area (memory for both omp and opencode). Do not read or write anything outside `Agents/` — including vault-wide searches — without explicit user approval in the conversation.

## Syntax

```bash
obsidian <command> [subcommand] [key=value ...]   # quote values with spaces
```

- Paths are **vault-relative** (`folder/note.md`), never absolute.
- `create` omits `.md`; `move`/`delete` include it.

## Read & write

```bash
obsidian read path="Agents/memory.md"
obsidian create path="folder/note" content="# New Note"
obsidian create path="folder/note" template="meeting-notes"
obsidian append path="folder/note.md" content="New paragraph"
obsidian prepend path="folder/note.md" content="Top content"
obsidian move path="old/note.md" to="new/note.md"
obsidian delete path="folder/note.md"
```

## Daily notes

```bash
obsidian daily:read
obsidian daily:append content="- [ ] New task"
obsidian daily:prepend content="## Morning Notes"   # inserts after frontmatter
```

## Search

```bash
obsidian search query="project alpha"
obsidian search query="TODO" path="projects" limit=10
obsidian search query="meeting" format=json   # JSON array of file paths
```

## Tasks, properties, tags, links

```bash
obsidian tasks                              # all tasks; grep "\[ \]" for open only
obsidian tasks done
obsidian task path="note.md" line=12 toggle
obsidian properties path="note.md"
obsidian property:set path="note.md" name="status" value="active"
obsidian tags counts sort=count
obsidian backlinks
obsidian orphans
obsidian unresolved
```

## Gotchas

1. Obsidian must be running. Empty output → check the app.
2. Electron/GPU warnings on stderr are noise: `2>/dev/null`.
3. `property:set` stores list values as literal strings — for YAML arrays, edit frontmatter via `read` → rewrite, or use `eval`.
4. `eval` (arbitrary JS against `app.*`) requires **single-line** code; write multiline scripts to a temp file and pass `code="$(cat /tmp/obs.js)"`.
5. `template:insert` targets the active file in the UI, takes no `path=`. To create from a template headlessly: `create path="..." template="..."`.
6. Output is pipe-friendly (`grep`, `jq`).

## Troubleshooting

| Problem | Fix |
|---|---|
| Empty output / hangs | Start Obsidian, re-run |
| Command not found | Re-enable CLI: Settings → Command line interface |
| Wrong vault targeted | Pass vault name as first arg (`obsidian "obsidian-vault" ...`) — rarely needed, single vault |
