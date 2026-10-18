---
name: dependabot
description: Triage, review, and (after explicit user approval) merge the open Dependabot PRs in the current GitHub repo. Use when the user asks to look at, review, handle, or merge Dependabot / dependency-bump PRs.
---

# Dependabot PR triage and merge

This skill is the one sanctioned exception to the global "no git operations" policy. Within it you may:
- post `@dependabot rebase` / `@dependabot recreate` comments on Dependabot PRs
- re-run CI on Dependabot PRs (`gh run rerun`)
- merge Dependabot PRs with `gh pr merge`

You may do these only after the user approves the plan from step 4, and only for the PRs that plan names. Everything else in the git policy still applies: no local commits, checkouts, pulls, branches, or pushes, and no editing PR branches.

## 1. Gather

```sh
gh pr list --author app/dependabot --state open --json number,title,headRefName,headRefOid,createdAt,mergeable,mergeStateStatus,statusCheckRollup
gh repo view --json viewerDefaultMergeMethod,nameWithOwner
```

Read `.github/dependabot.yml` if present. Its comments often record decisions, such as pinned or ignored majors.

For each PR, collect:
- `gh pr diff N --name-only`: the changed files
- `gh pr diff N`: the version changes from manifests and lockfiles. Filter out integrity hashes and checksum lines.
- `gh pr view N --json body,commits`: the release notes and the commit authors

## 2. Assess each PR

- **Integrity.** Every commit must be authored by `dependabot[bot]`. Only manifests, lockfiles, and workflow files may change. If anything else changed, flag the PR and do not merge it.
- **Bump size.** Patch, minor, or major. Grouped PRs: list every package that moves.
- **Security.** Look for GHSA/CVE references or security-relevant fixes in the release notes. Mention them; they raise the PR's priority.
- **Majors.** Read the breaking-changes section. Grep the codebase for usage of the affected APIs. State whether this repo is affected. A major is never a rubber stamp.
- **Relevance.** Say what the dependency does in this project (direct or transitive, runtime or dev-only, which feature uses it). Use project memory where it helps, for example "the SES adapter is only a fallback".
- **CI.** Every check must be `SUCCESS`. Pending, failing, or missing checks mean the PR is not mergeable yet.
- **Staleness.** CI is stale if main has moved since the PR's base. Check with `gh api repos/{owner}/{repo}/compare/{headRefOid}...main --jq .ahead_by`; a value > 0 means main has commits the PR's CI never ran against.
- **Conflicts.** Note PRs that touch the same lockfile. After one merges, the others need a rebase.

## 3. Order

Put security fixes first, then small PRs before large groups, then everything else. Majors go last and may be left out.

## 4. Report and ask

Present a table: PR, what it does, bump size, CI state (fresh, stale, or failing), risk, and a recommendation (merge, rebase then merge, hold, or skip). Add short notes on security fixes and majors.

Then propose a concrete plan, for example: "Merge #33, then rebase #32 and merge it once CI is green; rebase #30 (stale CI) and merge it once green; hold #31 (major, see notes)." Ask the user to approve it. Approval covers exactly that plan. If anything changes the plan along the way (a new failure, a new conflict, a new commit on a PR branch), stop and ask again.

## 5. Execute (after approval only)

Merge each PR with the repo's default method (`viewerDefaultMergeMethod`; use `--squash` if it is unset) and pin it to the reviewed commit:

```sh
gh pr merge N --squash --match-head-commit <headRefOid>
```

`--match-head-commit` makes the merge fail if the branch changed after review. Never use `--admin` or `--auto`, and never bypass a failing or pending check.

When a PR needs fresh CI, because it was stale or another merge touched the same lockfile:
1. Comment `@dependabot rebase` with `gh pr comment N --body "@dependabot rebase"`. If Dependabot refuses because the PR was edited, report it and skip that PR.
2. Wait for the new head commit, then watch CI with `gh pr checks N --watch` in the background.
3. Re-run the integrity and CI checks against the new `headRefOid`, then merge pinned to that oid.

## 6. Wrap up

Report what merged (with the resulting commit SHAs), what was skipped or held and why, and anything still in progress. Do not pull or update the local checkout. The user does that.
