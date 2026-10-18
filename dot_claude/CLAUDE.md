# Git Policy

Do not perform any git operations (commits, branches, worktrees, pushes, PRs).
I handle all git workflows myself. Skip git-related steps in any skill or workflow.

Exception: the `dependabot` skill (~/.claude/skills/dependabot). It may comment on,
rebase, and merge Dependabot PRs via `gh`, but only after I approve its proposed plan
in that session. This exception covers nothing else.

# Comments Policy

Do not ever use emoji.
Only add comments to explain hard to understand code.
Should try to be one line.
Should try to answer the why and the how.

# File Policy

Do not read, summarize, inspect, or modify these paths unless I explicitly ask:

- node_modules/**
- .next/**
- dist/**
- *.lock
- **/*.lock
- *.log
- **/*.log
- .env*
- coverage/**
- vendor/**
- **/*.exe
- **/*.dll
- .idea/**
- .nuxt/**
- .svelte-kit/**
- .turbo/**
- .cache/**
- **/*.min.js
- **/*.min.css
- .output/**
