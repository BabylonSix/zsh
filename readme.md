# BRAVØ ZSH Dotfiles

A personal productivity system for macOS optimized for learning velocity and workflow automation.

## Philosophy: Minimum Viable Friction Development

- **Single Command Philosophy** — Complex operations reduce to one keystroke
- **Automate Cognitive Load** — If you think about it twice, script it
- **Eliminate Context Switching** — Remove anything that breaks flow state
- **Instant Environment Recovery** — Any Mac becomes "your machine" in one command
- **Pattern-Based Discoverability** — Consistent naming creates intuitive mental models
- **Error States as Learning** — Failures teach correct usage through visual feedback

## Quick Start
```zsh
# Install (symlink startup.sh to .zshrc)
ln -sf ~/.dotfiles/zsh/startup.sh ~/.zshrc
zsh -l
setupzsh      # ~30 minutes for full provisioning

# Daily use
reload        # Apply config changes (or just: r)
us            # Update entire dev stack
us -a         # Update + interactive Node/Python version selection
ezsh          # Quick reference (opens dotfiles in editor)
i             # Show version info for all package managers
```

## Core Commands

| Command | Action |
|---------|--------|
| `setupzsh` | Provision new machine from zero |
| `wipezsh` | Complete removal (leave no trace) |
| `resetzsh` | Fresh start (wipe + setup) |
| `upgradezsh` | Update to latest ZSH version |
| `us` | Universal system update |
| `us -n` | Update + interactive Node version picker |
| `us -p` | Update + interactive Python version picker |
| `us -a` | Update + both version pickers |
| `us -h` | Show help |

## Architecture
```
~/.dotfiles/
├── zsh/
│   ├── startup.sh          # Entry point (symlink to ~/.zshrc)
│   ├── zsh-management.sh   # setupzsh, wipezsh, resetzsh, us
│   ├── path.sh             # PATH configuration
│   ├── package-managers.sh # Homebrew, NVM, pyenv, zinit
│   ├── colors.sh           # 256-color system + starship prompt
│   ├── shell.sh            # ZSH options and keybindings
│   ├── completion.sh       # Tab completion configuration
│   ├── alias.sh            # 200+ shortcuts
│   ├── tools.sh            # Custom functions and utilities
│   ├── directory-tools.sh  # Navigation helpers
│   ├── directories.sh      # Predefined directory shortcuts
│   ├── git.sh              # Git aliases and functions
│   ├── ssh.sh              # SSH configuration
│   ├── node-setup.sh       # Node.js global packages
│   ├── node-tools.sh       # NVM/NPM helpers
│   └── test-tools.sh       # Sandbox for new functions
├── config/
│   ├── nvim/               # Neovim configuration
│   ├── tmux/               # tmux configuration
│   ├── yazi/               # Yazi file manager
│   ├── zed/                # Zed editor
│   ├── ghostty/            # Ghostty terminal
│   └── starship.toml       # Starship prompt
└── web/                    # Web project tools (optional)
```

## Installed Tools

`setupzsh` installs these via Homebrew:

| Tool | Purpose |
|------|---------|
| `bat` | cat with syntax highlighting |
| `btop` | Modern system monitor |
| `eza` | Modern ls replacement |
| `fd` | Fast find alternative |
| `fzf` | Fuzzy finder |
| `lazygit` | Git TUI |
| `neovim` | Text editor |
| `nvm` | Node version manager |
| `pyenv` | Python version manager |
| `ripgrep` | Fast grep (rg) |
| `starship` | Cross-shell prompt |
| `tmux` | Terminal multiplexer |
| `trash` | Safe rm |
| `tree` | Directory visualization |
| `yazi` | Terminal file manager |
| `yt-dlp` | YouTube downloader |
| `zinit` | ZSH plugin manager |
| `zoxide` | Smart cd |

GUI apps: `ghostty`, `zed`

ZSH plugins: `zsh-syntax-highlighting`, `zsh-autosuggestions`, `F-Sy-H`

## System Update (`us`)

The `us` command is an interactive system updater with optional version management:
```zsh
us            # Safe daily driver — updates Homebrew, NPM, runs maintenance
us -n         # Also opens interactive Node version picker (fzf menu)
us -p         # Also opens interactive Python version picker (fzf menu)
us -a         # Both Node and Python pickers
us -np        # Same as -a
us -h         # Show help
```

**Version pickers:**
- Show only uninstalled versions (no duplicates)
- Newest versions first
- Node menu shows LTS labels
- Arrow keys to navigate, type to filter, Enter to select, Esc to cancel

## Command Patterns

### Naming Conventions

| Pattern | Usage | Examples |
|---------|-------|----------|
| 1-2 chars | High frequency | `u`, `l`, `gs`, `ga` |
| 3-4 chars | Tool+action fusion | `nvmu`, `npms` |
| lowercase compound | Dangerous operations | `setupzsh`, `wipezsh` |
| camelCase | Script/programmatic | `charCount`, `screenSize` |

### Edit Configuration (`e` + component)

| Alias | Opens |
|-------|-------|
| `ea` | alias.sh |
| `etools` / `et` | tools.sh |
| `epath` | path.sh |
| `egit` | git.sh |
| `essh` | ssh.sh |
| `eshell` | shell.sh |
| `ecolor` | colors.sh |
| `edir` | directory-tools.sh |
| `edirs` | directories.sh |
| `enpm` | node-setup.sh |
| `ezsh` | entire zsh folder |

### Navigation (`h` + location)

| Alias | Goes to |
|-------|---------|
| `hd` | ~/Desktop |
| `hl` | ~/Downloads |
| `hp` | ~/Personal Projects |
| `hwp` / `hw` | ~/Web Projects |
| `hzsh` | ~/.dotfiles/zsh |
| `he` | ~/Experiments |

### Directory Movement

| Command | Action |
|---------|--------|
| `u` ... `u9` | Move up 1-9 directory levels |
| `b` | Go back (cd -) |
| `t` | Tree (excludes node_modules) |
| `t2` ... `t9` | Tree with depth 2-9 |
| `y` | Yazi file manager (cd on exit) |

### Listing (eza-powered)

| Alias | Shows |
|-------|-------|
| `l` | Basic list |
| `ll` | Long format |
| `la` | Include hidden |
| `lla` | Long + hidden |
| `lh` | Hidden only |
| `lm` | Sort by modified |

### Git Shortcuts

| Alias | Command |
|-------|---------|
| `gs` | git status |
| `ga` | git add + status |
| `gc "msg"` | git commit -vm |
| `gg "msg"` | git add . + commit |
| `gd` | git difftool (Kaleidoscope) |
| `gpl` | git pull |
| `gpsh` | git push |
| `gf` | Stash (freeze) |
| `guf` | Stash apply (unfreeze) |
| `gb` | git branch |
| `gco` | git checkout |
| `gl` | git log --oneline |
| `lg` | lazygit |

### Node/NPM

| Command | Action |
|---------|--------|
| `nvml` | nvm list |
| `nvmu <ver>` | Set default node version |
| `nvmup` | Upgrade node + reinstall packages |
| `npms` | npm install --save |
| `npmd` | npm install --save-dev |
| `npmi` | npm init |
| `npml` | List local packages |
| `npmg` | List global packages |

### System

| Command | Action |
|---------|--------|
| `c` | clear |
| `h` | cd ~ + list |
| `e` | exit |
| `ka` | killall -9 |
| `tu` | btop (system monitor) |
| `fp <name>` | Find process |
| `kn <name>` | Kill named process |
| `ram <GB>` | Create RAM disk |

### Utilities

| Command | Action |
|---------|--------|
| `cat` | bat (syntax highlighting) |
| `srm` | trash (safe rm) |
| `compare` | Kaleidoscope diff |
| `ot <file>` | Open in default editor |
| `ob [url]` | Open in default browser |
| `zipr <dir>` | Zip directory |
| `sch <path>` | Take ownership (chown) |
| `v <vol>` | cd to /Volumes/<vol> |

### YouTube

| Alias | Action |
|-------|--------|
| `yt` | yt-dlp |
| `yd` | Download video (1080p + audio) |
| `ya` | Download audio only |
| `ycc` / `ysub` | Download subtitles |
| `yF` | List formats |
| `yu` | Update yt-dlp |

## Error Handling

Functions use color-coded, educational error messages:
```zsh
if [[ -z $1 ]]; then
  print "\n${RED}ERROR:${NC}"
  print "\n  Clear explanation of what's missing"
  print "\n  ${GREEN}command${NC} ${RED}<required-param>${NC}"
fi
```

## PATH Precedence

Deterministic tool resolution (brew → system):
```
/opt/homebrew/bin
/opt/homebrew/sbin
/opt/homebrew/opt/sqlite/bin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
```

View with: `path`

## Extending

1. **Follow existing patterns** — `e`+component, `h`+location
2. **Add aliases** — Every function gets a short alias
3. **Visual errors** — Color-coded with usage examples
4. **Self-document** — Inline comments in package arrays
5. **Maintain modularity** — Add to existing files when possible

## Reference

- `ezsh` — Open dotfiles folder for command lookup
- `reload` / `r` — Reload configuration
- `i` — Show all package manager versions
- `kb` — Show ZSH keybindings

## Documentation

- [CLAUDE.md](CLAUDE.md) — AI assistant guidance for this codebase
- [ZSH Prompt Expansion](https://zsh.sourceforge.io/Doc/Release/zsh_toc.html#SEC_Contents) — Official ZSH docs
- [256 Colors Cheat Sheet](https://www.ditig.com/256-colors-cheat-sheet) — Xterm color codes
