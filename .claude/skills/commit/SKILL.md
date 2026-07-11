---
name: commit
description: Create a git commit for this repo. Stages all pending changes (tracked and untracked, excluding secrets) and writes a short, single-line commit message. Use when the user says "commit", "commit this", "/commit", or asks to save current changes to git.
---

# Commit

Create a git commit that captures **everything** currently changed in the
working tree, with a **short** message.

## Steps

1. Run in parallel:
   - `git status` (never `-uall`)
   - `git diff` (unstaged) and `git diff --staged`
   - `git log --oneline -10` (match this repo's message style)

2. Stage **all** changes needed to fully capture the current state:
   - All modified tracked files.
   - All new/untracked files that belong in the repo (exam PDFs, scripts,
     Swift source, etc.).
   - Stage files explicitly by path (`git add <path> ...`). Do not use
     `git add -A` or `git add .` blindly — skip anything that looks like a
     secret or credential file, and warn the user if one is present.
   - Do not leave any legitimate change unstaged — the point of this skill
     is that the resulting commit reflects the *entire* current diff, not a
     partial slice of it.

3. Write a **short** commit message:
   - One line, imperative mood (e.g. "Add 2026 ZAP exam PDFs", "Fix
     Sprachprüfung detail view layout").
   - No body/bullet points unless the change genuinely can't be summarized
     in one line — prefer one line even then.
   - No AI/tool self-references in the message text itself.

4. Commit via heredoc so formatting is exact:

   ```bash
   git commit -m "$(cat <<'EOF'
   <short message>

   Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>
   EOF
   )"
   ```

5. Run `git status` to confirm the working tree is clean (or only contains
   intentionally-excluded files) and report the result.

## Rules

- Follow the repo's git safety protocol: never `--force`, `--no-verify`,
  `--no-gpg-sign`, `reset --hard`, or amend unless the user explicitly asks.
- Only commit when the user has asked for a commit in this turn — this
  skill doesn't imply standing permission to commit later changes
  automatically.
- If a pre-commit hook fails, fix the issue, re-stage, and create a **new**
  commit — never amend to work around a failed hook.
- If there is nothing to commit, say so instead of creating an empty commit.
