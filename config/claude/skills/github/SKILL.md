---
name: github
description: Use this skill when the user wants to interact with GitHub using the GitHub CLI. Trigger when the user wants to find repositories, list or search issues, list or search pull requests, view PR details, read PR comments, find a PR by branch name, or perform other GitHub read operations. Also trigger when the user references a PR number, branch name, or issue number and wants information from GitHub.
type: anthropic-skill
version: "1.0"
---

# GitHub

## Overview

This skill uses the GitHub CLI (`ghclaude`) to find repositories, list and search issues and pull requests, read PR comments, match PRs by branch name, and retrieve other GitHub information. It interprets the user's intent, determines the correct repository context, constructs the appropriate `ghclaude` commands, and presents results clearly.

## Parameters

- **query** (required): What the user wants to find or view. Can be a natural language request, a PR number, a branch name, an issue number, or a search term.
- **repo** (optional): Target repository in `owner/repo` format. If omitted, inferred from the current git remote or asked from the user.
- **action** (optional): Explicit action override. One of: `find-repos`, `list-issues`, `view-issue`, `list-prs`, `view-pr`, `pr-comments`, `find-pr-by-branch`, `search`.

**Constraints for parameter acquisition:**
- You MUST infer the repo from `git remote get-url origin` when inside a git repository and repo is not provided
- You MUST strip `.git` suffix and convert SSH remotes (`git@github.com:owner/repo.git`) to `owner/repo` format
- You MUST ask the user for the repo only if it cannot be inferred and is required for the action
- You MUST infer the action from the query when action is not provided
- You MUST NOT ask for parameters that can be reasonably inferred from context

## Action Reference

| Action | ghclaude Command(s) |
|---|---|
| `find-repos` | `ghclaude repo list [owner]` or `ghclaude search repos <terms>` |
| `list-issues` | `ghclaude issue list --repo <repo> [filters]` |
| `view-issue` | `ghclaude issue view <number> --repo <repo>` |
| `list-prs` | `ghclaude pr list --repo <repo> [filters]` |
| `view-pr` | `ghclaude pr view <number-or-branch> --repo <repo>` |
| `pr-comments` | `ghclaude pr view <number> --repo <repo> --comments` |
| `find-pr-by-branch` | `ghclaude pr list --repo <repo> --head <branch>` |
| `search` | `ghclaude search issues`, `ghclaude search prs`, `ghclaude search repos` |

## Steps

### 1. Determine Repository Context

Identify the target repository before running any commands.

**Constraints:**
- You MUST run `git remote get-url origin` to detect the repo when inside a git directory
- You MUST parse both HTTPS (`https://github.com/owner/repo.git`) and SSH (`git@github.com:owner/repo.git`) remote formats
- You SHOULD also check `ghclaude repo view --json nameWithOwner -q .nameWithOwner` as a fallback
- You MUST use `--repo <owner/repo>` flag explicitly in all `ghclaude` commands rather than relying on implicit detection, unless the user is clearly asking about repos in general
- If no repo can be inferred and none was provided, you MUST ask the user before proceeding

### 2. Determine Action and Build Command

Map the user's query to the correct `ghclaude` command and flags.

**Constraints:**
- You MUST read the query carefully to identify: target (repo / issue / PR), operation (list / view / search / comment), and any filters (state, label, author, branch, assignee, date)
- You MUST apply sensible defaults for list commands: `--limit 20` unless the user asks for more or fewer results
- You MUST use `--json` with `-q` (jq) or `--template` when structured output aids readability; prefer human-readable output otherwise
- You MUST include `--state open` by default for PRs and issues unless the user specifies closed or all
- You SHOULD add `--web` flag guidance only if the user asks to open in browser

**Intent mapping examples:**
- "list open PRs" → `ghclaude pr list --repo <repo> --state open`
- "show PR 42" or "PR #42" → `ghclaude pr view 42 --repo <repo>`
- "comments on PR 42" → `ghclaude pr view 42 --repo <repo> --comments`
- "PR for branch feature/foo" → `ghclaude pr list --repo <repo> --head feature/foo`
- "my open issues" → `ghclaude issue list --repo <repo> --assignee @me`
- "find repos about neovim" → `ghclaude search repos neovim`
- "closed PRs by alice" → `ghclaude pr list --repo <repo> --state closed --author alice`
- "issues with label bug" → `ghclaude issue list --repo <repo> --label bug`

### 3. Execute and Present Results

Run the command and present the output clearly.

**Constraints:**
- You MUST run the constructed `ghclaude` command using Bash
- You MUST check for errors: if `ghclaude` is not authenticated, instruct the user to run `ghclaude auth login`
- You MUST present list results as a readable summary (number, title, author, date, state)
- You MUST present `view` results with the full description and key metadata (author, state, labels, reviewers, checks summary if available)
- You MUST present PR comments grouped by commenter with timestamps when showing `--comments` output
- You SHOULD highlight the PR branch name, base branch, and merge status when viewing a PR
- You SHOULD note if a list is truncated and suggest adding `--limit` or filters to narrow results
- You MUST NOT fabricate or summarize data that was not returned by `ghclaude` — only present what the CLI returned

### 4. Offer Follow-up Actions

After presenting results, suggest logical next steps.

**Constraints:**
- You MUST offer relevant follow-up options based on what was shown:
  - After listing PRs: offer to view a specific PR or its comments
  - After viewing a PR: offer to show comments, open in browser (`ghclaude pr view --web`), or check out the branch (`ghclaude pr checkout <number>`)
  - After listing issues: offer to view a specific issue
  - After finding a PR by branch: offer to view it or show its comments
- You SHOULD only list follow-up options that make sense for the current result
- You MUST NOT automatically perform follow-up actions without user confirmation

## Common Flag Reference

| Flag | Purpose |
|---|---|
| `--repo owner/repo` | Target a specific repository |
| `--state open\|closed\|merged\|all` | Filter by state |
| `--author username` | Filter by author (`@me` for current user) |
| `--assignee username` | Filter by assignee (`@me` for current user) |
| `--label name` | Filter by label (can repeat) |
| `--head branch` | Filter PRs by head/source branch |
| `--base branch` | Filter PRs by base/target branch |
| `--limit N` | Max results to return (default 20) |
| `--comments` | Include comments in PR/issue view |
| `--web` | Open the item in the browser |
| `--json fields` | Output as JSON with specified fields |
| `-q jq-expr` | Filter JSON output with jq |

## Examples

### List open PRs
```
User: show me open PRs
ghclaude pr list --repo owner/repo --state open --limit 20
```

### View a specific PR
```
User: show PR 123
ghclaude pr view 123 --repo owner/repo
```

### Read PR comments
```
User: what are the comments on PR 42?
ghclaude pr view 42 --repo owner/repo --comments
```

### Find PR by branch name
```
User: is there a PR for the branch feature/dark-mode?
ghclaude pr list --repo owner/repo --head feature/dark-mode
```

### List issues assigned to me
```
User: what issues are assigned to me?
ghclaude issue list --repo owner/repo --assignee @me --state open
```

### Search for repositories
```
User: find GitHub repos related to neovim lua plugins
ghclaude search repos neovim lua plugins --limit 20
```

### List repos for an org
```
User: list repos in the acme org
ghclaude repo list acme --limit 30
```

### Closed PRs by a specific author
```
User: show closed PRs by alice
ghclaude pr list --repo owner/repo --state closed --author alice
```

## Troubleshooting

### Not authenticated
If `ghclaude` returns an auth error:
- Instruct the user to run `ghclaude auth login` and follow the prompts
- After login, re-run the original command

### Repo not found
If the repo cannot be inferred or the user's provided repo returns a 404:
- Confirm the `owner/repo` spelling with the user
- Suggest `ghclaude repo list <owner>` to verify available repos

### No results returned
If a list command returns nothing:
- Check if `--state` is filtering out results (try `--state all`)
- Check if `--author` or `--label` filters are too restrictive
- Suggest broadening or removing filters

### Branch not found for PR lookup
If `--head <branch>` returns no results:
- The branch may not have an open PR; try `--state all`
- The branch name may differ — suggest `ghclaude pr list` without the head filter to browse
