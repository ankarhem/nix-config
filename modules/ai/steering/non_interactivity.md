# Shell Non-Interactive Strategy

No TTY. Any command that waits for input, confirmation, or opens a UI hangs until timeout.
Treat this as headless CI.

## Rules

1. Preemptively supply yes/force flags on every command if needed.
2. Never use editors, pagers, REPLs, or `-i`/`-p` interactive modes.
3. Prefer your built-in Read/Write/Edit tools over `sed`/`echo`/`cat` for file changes.
4. Use `jq` for JSON, not `python -c "import json..."`.
5. Overall, prefer native tools over adhoc Python scripts.
6. Keep driving the task. Don't stop after a tool call to wait for instructions
   unless the task is done.

## Banned — will hang

vim vi nano emacs ed · less more most pg · man
git commit (no -m) · git add -p · git rebase -i
python node irb ghci (bare) · bash -i · docker run -it · docker exec -it

## When there's no flag

yes | ./script.sh
./configure.sh <<EOF … EOF
timeout 30 ./script.sh || echo "timed out"
cmd --help | grep -iE "non-interactive|force|yes"
