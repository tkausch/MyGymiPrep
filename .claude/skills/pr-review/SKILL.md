---
name: pr-review
description: Review a GitHub pull request against this repo's conventions (PDF naming, data/ layout, download scripts, SwiftUI views). Use when the user asks to review a PR, gives a PR number/URL, or says "review the pull request" / "/pr-review". For reviewing local uncommitted changes instead, use /code-review.
---

# PR Review

Review a GitHub pull request for this repo (ZAP exam archive + the
MyGymiPrep SwiftUI app) and report findings.

## Steps

1. Resolve the PR:
   - If given a number or URL, use `gh pr view <n> --json ...` and
     `gh pr diff <n>` to get metadata and the full diff.
   - If not given, run `gh pr list` and ask which one.

2. Read the full diff (`gh pr diff <n>`) before opining — don't review from
   the title/description alone.

3. Check against this repo's actual conventions:

   **Data changes (`data/**`)**
   - New PDFs live under `gymi_langgymnasium/` or `gymi_kurzgymnasium/`,
     inside `deutsch/`, `mathematik/`, or `merkblatt/`.
   - Filenames follow `{year}_{subject}_{type}[_{track}].pdf` per
     CLAUDE.md (`_aufgaben`/`_loesung(en)`, `_lg`/`_kg`/`_kg_hms`). Flag
     filenames that break the pattern — unless they're deliberately
     replicating a known upstream naming defect (see the two known
     extensionless files already in the repo).
   - Changes to `gymi_langzeitgymnasium_downloads.sh` /
     `gymi_kurzgymnasium_downloads.sh`: new entries should be added to the
     `declare -a` arrays following the existing URL pattern; check the
     script still assumes it's run from inside `data/`.
   - PDFs should not be silently modified/re-encoded without reason — flag
     unexplained binary diffs to existing (not new) PDFs.

   **App changes (`MyGymiPrep/**`)**
   - SwiftUI views: check state/logic isn't duplicated across
     `*ListView` / `*DetailView` pairs when it could reuse `Theme.swift` or
     shared view models.
   - New views for a track/subject should mirror the existing structure
     (e.g. `MathTaskListView`/`MathTaskDetailView`,
     `SprachpruefungListView`/`SprachpruefungDetailView`) rather than
     inventing a new pattern.
   - Flag force-unwraps, hardcoded file paths, or logic that assumes only
     one track/subject when the app already models both LG and KG.

   **General**
   - Correctness bugs, obvious crashes, unhandled edge cases.
   - Scope creep: does the diff match what the PR description claims?
   - Anything a reviewer would block on vs. just note.

4. Report findings grouped by severity (blocking / worth fixing / nit).
   For each: file:line, what's wrong, why it matters. Don't pad the report
   with restating what the diff already makes obvious.

5. If asked to post the review, use
   `gh pr review <n> --comment -b "..."` (or `--approve` / `--request-changes`
   only if the user explicitly asks for that verdict) rather than deciding
   the verdict unilaterally.
