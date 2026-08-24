# Tool Setup

Steps to set up tmux, Claude Code, Neovim, and zsh on a new machine from this
repo. Not covered by `install.sh` / `update.sh` — those only handle i3, kitty,
polybar, rofi, dunst, picom, the old `zshrc` (see Zsh section below for why
that's stale), and the wallpaper.

## tmux

```bash
ln -sf ~/Projects/dotfiles/config/tmux/tmux.conf ~/.tmux.conf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then start tmux and press `prefix + I` (capital I) to install the plugins
declared in `tmux.conf` (`tmux-resurrect`, `tmux-continuum`).

Note: `@continuum-restore 'on'` means continuum auto-restores the last saved
session on tmux start. On first launch there's no save file yet, so this is a
no-op — expected, not a bug. Continuum also auto-saves session state every 15
minutes in the background.

## Claude Code

```bash
cp ~/Projects/dotfiles/config/claude/CLAUDE.md ~/.claude/CLAUDE.md
cp ~/Projects/dotfiles/config/claude/settings.json ~/.claude/settings.json
cp -r ~/Projects/dotfiles/config/claude/skills/* ~/.claude/skills/
```

These are plain copies, not symlinks — `~/.claude` is a live state directory
(sessions, history, credentials, etc.), so only specific files are pulled in
from the repo, not the whole directory.

Note: the `github` skill uses `ghclaude` (not `gh`) as the CLI — that's
intentional on this setup, not a typo.

**Keeping in sync:** these files can drift from the repo over time (settings
get tweaked live, skills get edited). Before setting up a new machine, diff
`~/.claude/settings.json` and `~/.claude/skills/**` against the repo copies
and re-sync the repo from the live machine if needed, since the live config
is the source of truth.

## Neovim

Current config is Lua-based (packer.nvim), lives in `config/nvim-latest/`.
The old `config/nvim/init.vim` (vim-plug based) is kept for reference but is
superseded — don't set that one up.

```bash
mkdir -p ~/.config/nvim
ln -sf ~/Projects/dotfiles/config/nvim-latest/init.lua ~/.config/nvim/init.lua
ln -sf ~/Projects/dotfiles/config/nvim-latest/lua ~/.config/nvim/lua

git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Then start nvim and run `:PackerSync` to install the rest of the plugins
declared in `lua/user/packer.lua` (`telescope.nvim` + `plenary.nvim`,
`rose-pine`, `nvim-treesitter`).

## Zsh

`zshrc_latest` (repo root) is the current config — `zshrc` (no suffix) is an
old Arch/i3-era config that's stale and superseded, don't use it.

```bash
cp ~/Projects/dotfiles/zshrc_latest ~/.zshrc
chsh -s "$(which zsh)"   # if zsh isn't already the login shell
```

External dependencies this config expects (install separately, config
degrades gracefully if missing since bun/gcloud lines are existence-checked):
- `starship` — prompt, via `eval "$(starship init zsh)"` (not existence-checked,
  will error on shell start if not installed)
- `bun` — completions + `$BUN_INSTALL/bin` on PATH
- `opencode` CLI — expected at `~/.opencode/bin`
- LM Studio CLI (`lms`) — expected at `~/.lmstudio/bin`
- Google Cloud SDK — expected at `~/Downloads/google-cloud-sdk`

Note: the `ghclaude` alias (line with `GH_TOKEN=github_pat_****`) is a
placeholder, not a working alias — it no longer invokes `gh`. Replace it with
a real token/command before relying on the `github` Claude skill, which calls
`ghclaude` directly.
