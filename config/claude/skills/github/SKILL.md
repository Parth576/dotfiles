---
name: github
description: Use this skill when the user wants to interact with GitHub using the GitHub CLI. Trigger when the user wants to find repositories, list or search issues, list or search pull requests, view PR details, read PR comments, find a PR by branch name, create or edit issues, create or edit pull requests, comment on issues or PRs, or perform other GitHub operations. Also trigger when the user references a PR number, branch name, or issue number and wants information from GitHub.
type: anthropic-skill
version: "1.0"
---

# GitHub

## Overview

This skill uses the GitHub CLI (`ghclaude`) to find repositories, list and search issues and pull requests, read PR comments, match PRs by branch name, create and edit issues and pull requests, comment on issues and PRs, and retrieve other GitHub information. It interprets the user's intent, determines the correct repository context, constructs the appropriate `ghclaude` commands, and presents results clearly.

## Parameters

- **query** (required): What the user wants to find or view. Can be a natural language request, a PR number, a branch name, an issue number, or a search term.
- **repo** (optional): Target repository in `owner/repo` format. If omitted, inferred from the current git remote or asked from the user.
- **action** (optional): Explicit action override. One of: `find-repos`, `list-issues`, `view-issue`, `create-issue`, `edit-issue`, `close-issue`, `reopen-issue`, `comment-issue`, `list-prs`, `view-pr`, `create-pr`, `edit-pr`, `close-pr`, `merge-pr`, `comment-pr`, `review-pr`, `pr-comments`, `find-pr-by-branch`, `search`.

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
| `create-issue` | `ghclaude issue create --repo <repo> --title <title> [--body <body>] [--label <label>] [--assignee <user>]` |
| `edit-issue` | `ghclaude issue edit <number> --repo <repo> [--title <title>] [--body <body>] [--add-label <label>] [--remove-label <label>]` |
| `close-issue` | `ghclaude issue close <number> --repo <repo> [--reason <completed\|not_planned>]` |
| `reopen-issue` | `ghclaude issue reopen <number> --repo <repo>` |
| `comment-issue` | `ghclaude issue comment <number> --repo <repo> --body <body>` |
| `create-pr` | `ghclaude pr create --repo <repo> --title <title> [--body <body>] [--base <branch>] [--head <branch>] [--draft]` |
| `edit-pr` | `ghclaude pr edit <number> --repo <repo> [--title <title>] [--body <body>] [--add-label <label>] [--add-reviewer <user>]` |
| `close-pr` | `ghclaude pr close <number> --repo <repo>` |
| `merge-pr` | `ghclaude pr merge <number> --repo <repo> [--merge\|--squash\|--rebase] [--delete-branch]` |
| `comment-pr` | `ghclaude pr comment <number> --repo <repo> --body <body>` |
| `review-pr` | `ghclaude pr review <number> --repo <repo> [--approve\|--request-changes\|--comment] [--body <body>]` |
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
- "create an issue about login bug" → `ghclaude issue create --repo <repo> --title "Login bug" --body "<details>"`
- "close issue 15" → `ghclaude issue close 15 --repo <repo>`
- "comment on issue 8 saying it's fixed" → `ghclaude issue comment 8 --repo <repo> --body "It's fixed"`
- "create a PR for this branch" → `ghclaude pr create --repo <repo> --title "<title>" --body "<body>"`
- "create a draft PR" → `ghclaude pr create --repo <repo> --title "<title>" --draft`
- "merge PR 50 with squash" → `ghclaude pr merge 50 --repo <repo> --squash --delete-branch`
- "approve PR 33" → `ghclaude pr review 33 --repo <repo> --approve`
- "request changes on PR 33" → `ghclaude pr review 33 --repo <repo> --request-changes --body "<feedback>"`
- "add label bug to issue 12" → `ghclaude issue edit 12 --repo <repo> --add-label bug`

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
- For write operations (create, edit, close, merge, comment, review): you MUST confirm the action with the user before executing, showing exactly what will be created/modified
- You MUST NOT create issues or PRs with placeholder content — always use the user's actual intent for titles and bodies
- When creating a PR, you MUST infer the head branch from the current git branch (`git branch --show-current`) if not specified
- When creating a PR, you SHOULD default `--base` to the repo's default branch if not specified
- When merging a PR, you SHOULD ask the user for merge strategy (merge, squash, rebase) if not specified

### 4. Offer Follow-up Actions

After presenting results, suggest logical next steps.

**Constraints:**
- You MUST offer relevant follow-up options based on what was shown:
  - After listing PRs: offer to view a specific PR, its comments, or merge/close one
  - After viewing a PR: offer to show comments, approve/review, merge, open in browser (`ghclaude pr view --web`), or check out the branch (`ghclaude pr checkout <number>`)
  - After listing issues: offer to view a specific issue, close one, or comment on one
  - After viewing an issue: offer to comment, close, edit labels, or reassign
  - After finding a PR by branch: offer to view it, show its comments, or merge it
  - After creating an issue or PR: offer to view it in browser or add labels/reviewers
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
| `--title text` | Set title (create/edit issues and PRs) |
| `--body text` | Set body text (create/edit/comment) |
| `--draft` | Create PR as draft |
| `--add-label name` | Add a label (edit issues/PRs) |
| `--remove-label name` | Remove a label (edit issues/PRs) |
| `--add-reviewer user` | Add a reviewer (edit PRs) |
| `--merge` | Merge with a merge commit |
| `--squash` | Merge with squash |
| `--rebase` | Merge with rebase |
| `--delete-branch` | Delete branch after merging |
| `--reason completed\|not_planned` | Reason when closing an issue |

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

### Create an issue
```
User: create an issue about the broken dark mode toggle
ghclaude issue create --repo owner/repo --title "Broken dark mode toggle" --body "The dark mode toggle on the settings page does not persist the preference."
```

### Close an issue
```
User: close issue 23
ghclaude issue close 23 --repo owner/repo
```

### Comment on an issue
```
User: comment on issue 15 that this is a duplicate of issue 10
ghclaude issue comment 15 --repo owner/repo --body "Duplicate of #10"
```

### Create a pull request
```
User: create a PR for this branch
ghclaude pr create --repo owner/repo --title "Add dark mode support" --body "Implements dark mode toggle and persistence." --head feature/dark-mode
```

### Create a draft PR
```
User: create a draft PR
ghclaude pr create --repo owner/repo --title "WIP: Refactor auth module" --draft
```

### Merge a PR
```
User: squash merge PR 50
ghclaude pr merge 50 --repo owner/repo --squash --delete-branch
```

### Approve a PR
```
User: approve PR 33
ghclaude pr review 33 --repo owner/repo --approve
```

### Request changes on a PR
```
User: request changes on PR 33, the tests are missing
ghclaude pr review 33 --repo owner/repo --request-changes --body "Please add tests for the new endpoints."
```

### Add a label to an issue
```
User: add the bug label to issue 12
ghclaude issue edit 12 --repo owner/repo --add-label bug
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
