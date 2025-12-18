# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this ZSH dotfiles repository.

## System Philosophy: Minimum Viable Friction Development

This is a personal productivity system optimized for learning velocity and workflow automation. Core principles:

- **Single Command Philosophy**: Complex operations reduce to one keystroke/command
- **Automate Cognitive Load**: If you think about it twice, script it
- **Eliminate Context Switching**: Remove anything that breaks flow state
- **Instant Environment Recovery**: Any machine becomes "your machine" in one command
- **Pattern-Based Discoverability**: Systems are intuitive through consistent mental models
- **Error States as Learning**: Failures teach correct usage through visual, contextual feedback
- **Clarity Over Cleverness**: Explicit, self-documenting code over sophisticated but opaque solutions

## Architecture Overview

### Project Structure

```
~/.dotfiles/
├── zsh/                        # Shell configuration
│   ├── startup.sh              # Entry point (symlink to ~/.zshrc)
│   ├── zsh-management.sh       # setupzsh, wipezsh, resetzsh, us
│   ├── path.sh                 # PATH configuration
│   ├── colors.sh               # 256-color system + print wrapper
│   ├── shell.sh                # ZSH options, integrations (starship, zoxide, fzf)
│   ├── package-managers.sh     # Homebrew, NVM, pyenv, zinit
│   ├── directory-tools.sh      # Navigation helpers, eza/tree aliases
│   ├── directories.sh          # Predefined directory shortcuts
│   ├── tools.sh                # Custom functions and utilities
│   ├── node-management.sh      # NPM global packages manifest
│   ├── node-tools.sh           # NVM/NPM helpers
│   ├── completion.sh           # Tab completion
│   ├── ssh.sh                  # SSH configuration
│   ├── git.sh                  # Git aliases and functions
│   ├── alias.sh                # Edit/directory shortcuts
│   └── test-tools.sh           # Sandbox for new functions
├── config/                     # Tool configurations (symlinked to ~/.config/)
│   ├── nvim/                   # Neovim
│   ├── tmux/                   # tmux
│   ├── yazi/                   # Yazi file manager
│   ├── zed/                    # Zed editor
│   ├── ghostty/                # Ghostty terminal
│   └── starship.toml           # Starship prompt
└── web/                        # Web project tools (optional)
```

### Single-Command Provisioning System

- `setupzsh()`: Complete development environment from zero to productive (~30 min)
- `wipezsh()`: Clean removal for temporary machines (leave no trace)
- `resetzsh()`: Fresh start (wipe + setup)
- `upgradezsh()`: Update to latest ZSH version
- `us()`: Universal system update with optional version pickers (`-n` for Node, `-p` for Python, `-a` for both)

### Modular Package System

Packages are organized by dependency level in `zsh-management.sh`:

| Category     | Purpose                  | Safe to Remove?                  |
| ------------ | ------------------------ | -------------------------------- |
| **Core**     | Dotfiles depend on these | ❌ No — breaks aliases/functions |
| **DevTools** | Modern CLI replacements  | ✓ Yes                            |
| **Media**    | Audio/video work         | ✓ Yes                            |
| **Network**  | Network tasks            | ✓ Yes                            |
| **macOS**    | macOS utilities          | ✓ Yes                            |
| **GuiApps**  | Casks (GUI applications) | ✓ Yes                            |

```zsh
# Full provisioning
setupzsh          # Calls setupAllPackages() internally

# Selective installation
setupCore         # Just essentials (system won't break)
setupTools        # Dev tools
setupMedia        # Media tools
setupNetwork      # Network tools
setupApps         # GUI apps

# Safe removal examples
brew uninstall ffmpeg    # ✓ Safe: MediaTools
brew uninstall eza       # ✗ Dangerous: Core — breaks l, ll, la aliases
```

**Adding packages**: Find the correct category array, add with inline comment.

## J/K/L/I Navigation Philosophy

**Original design challenging traditional vim hjkl bindings.**

Physical key positions map directly to logical directions:

```
      I (up)
J (left)  L (right)
      K (down)
```

This creates muscle memory that transfers across ALL tools: yazi, neovim, tmux, lazygit, fzf.

## Command Patterns

### Usage Context-Based Naming

| Pattern            | Usage                         | Examples                  |
| ------------------ | ----------------------------- | ------------------------- |
| lowercase compound | Interactive terminal commands | `setupzsh`, `photosize`   |
| camelCase          | Script/programmatic functions | `screenSize`, `charCount` |

**Principle**: Don't create aliases for camelCase functions—they exist for script readability, not typing efficiency.

### Frequency-Based Naming Hierarchy

| Length                | Frequency                     | Examples                |
| --------------------- | ----------------------------- | ----------------------- |
| 1-2 chars             | High frequency, muscle memory | `u`, `l`, `gs`, `ga`    |
| 3-4 chars             | Medium frequency, tool+action | `nvmu`, `npms`          |
| Consonant compression | Avoid conflicts               | `ccnt`, `stst`, `psz`   |
| Descriptive           | Complex, self-documenting     | context determines case |

### Safety Through Naming Friction

- **lowercase**: Safe, frequent operations (no shift = fast)
- **compound lowercase**: Dangerous system operations (requires deliberate typing)
- **camelCase**: Script utilities (shift creates cognitive pause)

### Tool+Action Fusion

Eliminate flag memorization by merging common operations:

```zsh
nvml = nvm list
nvmu = nvm use
npms = npm install --save
npmd = npm install --save-dev
ga   = git add
gc   = git commit
gs   = git status
```

### Edit Configuration (`e` + component)

`ea`, `epath`, `egit`, `ezsh`, `evim`...

### Navigation (`h` + location)

`hd` (Desktop), `hp` (Personal Projects), `hzsh` (dotfiles), `hweb` (web projects)...

### Directory Movement

- `u`, `u2`...`u9`: Move up 1-9 levels
- `b`: Go back (cd -)
- `t`, `t2`...`t9`: Tree display with depth
- `y`: Yazi file manager (cd on exit)

## Error Handling Standard

Visual, educational error pattern:

```zsh
if [[ -z $1 ]]; then
  print "\n${RED}ERROR:${NC}"
  print "\n  Clear explanation of what's missing"
  print "\n  ${GREEN}command${NC} ${RED}<required-param>${NC}"
  print "\n  Additional context or examples"
  return 1
fi
```

Colors guide the user: RED for errors, GREEN for correct syntax, BLUE for actions, YELLOW for warnings.

## Development Guidelines

When extending this system:

1. **Follow Existing Patterns**: Use established command patterns
2. **Add Aliases**: Every function gets a short alias for single-command access
3. **Visual Error Handling**: Include colored, contextual error messages with usage examples
4. **Self-Document**: Add inline comments to package arrays explaining purpose
5. **Test Both States**: Verify success and failure behaviors
6. **Maintain Modularity**: Add to existing files rather than creating new ones
7. **Clarity Over Cleverness**: Explicit code beats clever abstractions
8. **Package Placement**: Add new packages to the correct category (Core only if dotfiles depend on it)

### Functions Over Aliases

All commands are functions to enable composability—functions can call other functions with arguments passing through correctly.

**What is Composability:**

When `functionA` calls `functionB` with arguments, those arguments reach their destination:

```zsh
# Three functions that work together
tree() { eza --tree --color=always -I ".git|node_modules" "$@"; }
tl() { tree -L "$@"; }
t2() { tl 2; }

# Call chain with arguments
$ t2 -a
# → t2 calls: tl 2 -a
# → tl calls: tree -L 2 -a
# → tree calls: eza --tree -L 2 -a
# Result: Arguments flow through all three functions to eza
```

Without `"$@"`, arguments get lost—`t2 -a` would drop the `-a` and only `2` would reach eza.

**Why This Matters:**

**Layering** — Build complex commands from simple ones:

```zsh
l() { clear; eza "$@"; }           # Base: list files
ll() { l -lh "$@"; }               # Layer: add long format
lla() { ll -a "$@"; }              # Layer: add hidden files
```

**Validation** — Add logic before calling other commands:

```zsh
md() {
  [[ $# = 0 ]] && { error_message; return 1; }
  mkdir -p "$1" && cd "$1" && l    # Calls l() function
}
```

**Orchestration** — Chain multiple functions into workflows:

```zsh
nvmup() {
  local latest=$(check_latest_version)
  nvmu "$latest"      # Calls nvmu() function
  npmstart            # Calls npmstart() function
}
```

**The Rule:**

Every function that accepts arguments must include `"$@"` to pass them through:

```zsh
# Correct
l() { clear; eza "$@"; }
srm() { trash "$@"; }

# Wrong - arguments won't pass through
l() { clear; eza }
srm() { trash }
```

This pattern enables the entire system's architecture—Tool+Action Fusion, depth controls, error handling, and workflow orchestration all depend on functions calling functions correctly.

## Future Architecture

### AI Project Context System (Planned)

**Goal**: Give multiple AI tools a shared whiteboard without forcing them into one schema.

Each LLM works however it works. Claude uses CLAUDE.md. Codex uses AGENTS.md. The system creates a **diplomatic channel** between them—not forced unification.

- **Scratch files** = working memory (per-LLM, messy, exploratory)
- **Shared context** = curated knowledge (version controlled, deliberate)

When one LLM figures something out, fold it into the shared context and tell the others: "read the notes." No copy-pasting between tools.

```
project/.ai/
├── CONTEXT.md          # Shared context (curated, version controlled)
├── claude/CLAUDE.md    # Claude-specific instructions
├── codex/AGENTS.md     # Codex agent definitions
├── gemini/GEMINI.md    # Gemini-specific context
└── scratch/            # Working notes per LLM
```

Commands: `aiinit`, `aisync`, `aiclean`, `aistatus`

### Creative Workflow Capture (Planned)

**Goal**: When you figure out how to do something, capture it so you don't reinvent it next time.

This is not "build platforms in advance." It's **incremental capture of working patterns as they emerge from real creative work**. The tooling grows by accretion, not planning.

- If you configure it twice, script it.
- If you set up a directory structure that works, templatize it.
- If you figure out a workflow, save it.

The friction being removed: "I have to remember how I did this last time."

Capture areas (as they emerge from use):

- Web project scaffolding
- n8n workflow export/import
- ComfyUI pipeline management
- Music release packaging (Spotify, Apple Music, YouTube, TikTok, ContentID)

## Quick Reference

```zsh
# Provisioning
setupzsh     # Full provisioning (all packages)
setupCore    # Just core packages
setupTools   # Add dev tools
setupApps    # Add GUI apps

# Daily use
us           # Update system (safe daily driver)
us -a        # Update + version pickers
reload / r   # Reload configuration
i            # Show all package manager versions
ezsh         # Quick reference (opens dotfiles)
```

## Documentation

- [README.md](readme.md) — User-facing documentation
- [TODO.md](TODO.md) — Master roadmap
- [Ethos-Alignment-TODO.md](Ethos-Alignment-TODO.md) — Quick wins checklist
