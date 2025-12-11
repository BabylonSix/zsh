# Ethos Alignment — Quick Wins

Tactical improvements to better align the codebase with **Minimum Viable Friction Development**.

> These are small, focused changes that can be knocked out in a single session.
> Each one removes a paper cut. Collectively, they compound into flow state.

---

## ✅ Completed

### Architectural Improvements

- [x] **Functions Over Aliases** — Complete refactor for composability
  - directory-tools.sh: f(), d(), lns(), o(), of(), od(), srm()
  - ssh.sh: sshl(), ssha()
  - All functions support proper argument passthrough via `"$@"`
  - Impact: Functions can now be composed, arguments flow through correctly

- [x] **Tree Migration to Eza** — Unified tool for ls and tree
  - Function: `tree() { eza --tree --color=always -I ".git|node_modules" "$@"; }`
  - Depth aliases: t(), t2-t9 working
  - Removed from Programs array
  - Impact: Consistent tool, better performance, respects gitignore

- [x] **Git Functions Refactor** — Better organization and error handling
  - Organized into logical sections (Status, Staging, Commits, Branches, etc.)
  - All functions properly quote arguments
  - Better error handling with visual feedback
  - Impact: More maintainable, safer, consistent patterns

- [x] **Node Tools Cleanup** — Simplified and more reliable
  - Removed dependency on external `revolver` tool
  - Simplified `nvmup()` logic
  - Better error handling throughout
  - Impact: Fewer dependencies, clearer code

### Error Handling (Error States as Learning)

- [x] **v()** — Disk volume selector with available volumes list
  - Shows list of available volumes when called without args
  - Clear error messaging
  - File: directory-tools.sh

- [x] **sch()** — Basic error handling (missing visual feedback)
  - Has error handling for missing path
  - Still needs success feedback (see below)
  - File: directory-tools.sh

- [x] **md()** — Directory creation with error handling
  - Validates directory name provided
  - Creates and navigates in one step
  - File: directory-tools.sh

- [x] **cho()** — Ownership change with syntax feedback
  - Error handling for missing arguments
  - Visual feedback on success/failure
  - File: tools.sh

- [x] **zipr()** — Zip with validation
  - Validates file/directory exists
  - Error handling for missing args
  - File: directory-tools.sh

### Provisioning

- [x] **First-run detection** — Interactive prompt
  - Checks for .✓ marker file
  - Prompts user to run setupzsh
  - Graceful exit if declined
  - File: startup.sh

- [x] **us() with fzf version pickers** — Interactive Node/Python version selection
  - `-n` flag for Node picker
  - `-p` flag for Python picker
  - `-a` flag for both
  - Shows only uninstalled versions
  - File: zsh-management.sh

- [x] **Color-coded progress** — Throughout setupzsh()
  - Blue arrows (→) for actions
  - Green checkmarks (✓) for success
  - Yellow warnings (⚠) for issues
  - Red errors for failures
  - File: zsh-management.sh

- [x] **Package modularization** — Core/Tools/Media/Network/macOS/Apps
  - Clear dependency levels
  - Safety indicators
  - Selective installation
  - File: zsh-management.sh

- [x] **Unified installer functions** — DRY package management
  - installBrewPackages() for CLI tools
  - installBrewCasks() for GUI apps
  - Category wrappers: setupCore(), setupTools(), etc.
  - File: zsh-management.sh

### Modern Tool Integration

- [x] **cat → bat** — Better cat with syntax highlighting
  - Alias: `alias cat='bat'`
  - File: tools.sh

- [x] **ls → eza** — Modern ls with better features
  - Functions: l(), ll(), la(), lla(), lh(), lm()
  - All support argument passthrough
  - File: directory-tools.sh

- [x] **top → btop** — Modern system monitor
  - Alias: `alias tu='btop'`
  - File: tools.sh

- [x] **cd → zoxide** — Smart directory navigation
  - Integrated via eval in shell.sh
  - Learns frequently used paths

- [x] **y() for yazi** — File manager with cd-on-exit
  - Properly handles temp files
  - Changes directory on exit
  - File: directory-tools.sh

---

## 🔴 High Priority (Violates Core Ethos)

### 1. Add Missing Short Aliases

**File:** `alias.sh`

```zsh
# Quick Look cache cleaner
alias cql='cleanQl'

# Python package management
alias pips='pip3 install'
alias pipu='pip3 install -U'
alias pipl='pip3 list'

# Tmux session management
alias tls='tmux list-sessions'
alias tks='tmux kill-session'
alias tas='tmux attach-session'

# Modern tool shortcuts (ensure accessible)
alias fd='fd'     # already installed via DevTools
alias rg='rg'     # already installed via ripgrep
```

**Impact**: Single-command access to frequently used operations

---

### 2. Add Visual Success Feedback to sch()

**File:** `directory-tools.sh`

Current `sch()` has error handling but no success feedback.

```zsh
sch() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}sch${NC} ${RED}<path>${NC}"
    return 1
  fi
  print "${BLUE}→ Taking ownership of${NC} ${YELLOW}$1${NC}"
  sudo chown -R "$(whoami)":admin "$1"
  print "${GREEN}✓ Ownership changed${NC}"
}
```

**Impact**: User knows operation succeeded without checking manually

---

## 🟡 Medium Priority (Consistency)

### 3. Rename Functions to Match Noun+Verb Pattern

**File:** `test-tools.sh`

**Manual terminal commands should use lowercase noun+verb:**

| Current | Rename To | Reason |
|---------|-----------|--------|
| `split_txt()` | `txtsplit()` | noun+verb: txt+split |

Keep old name as alias for backward compatibility:
```zsh
txtsplit() { ... }
alias split_txt='txtsplit'  # backward compatibility
```

**Impact**: Consistent naming pattern across all manual commands

---

### 4. Add Missing CLI Tools

**File:** `zsh-management.sh` DevTools array

```zsh
# Dev tools - not system critical but useful
DevTools=(
  bat                      # better cat
  bat-extras              # batgrep, batman, batdiff, prettybat
  btop                     # system monitor
  ripgrep                  # fast grep (rg)
  fd                       # fast find
  neovim                   # editor
  lazygit                  # git TUI
  tmux                     # terminal multiplexer
  yazi                     # file manager
  tldr                     # simplified man pages
  jq                       # JSON processor
  gdu                      # disk usage
)
```

**Impact**: Complete modern CLI toolkit

---

### 5. Clean Up Remaining Tree Aliases

**File:** `directory-tools.sh`

Remove legacy tree-specific aliases that don't make sense with eza:

```zsh
# Remove these:
# alias tll='tree -p'      # eza uses -l for long format
# alias tg='tree -g'       # group display not relevant
# alias to='tree -u'       # owner display not relevant
```

Keep what works:
- `tree()` — eza --tree wrapper ✓
- `t()` — shorthand ✓
- `tl()` — tree with depth ✓
- `t2-t9()` — specific depths ✓

**Impact**: No confusing legacy aliases that don't work with eza

---

### 6. Migrate grep to rg

**File:** `tools.sh`

Replace default grep with ripgrep for better performance and defaults:

```zsh
# Modern Tools section

# Use ripgrep as default (faster, respects .gitignore)
alias grep='rg'
alias grepo='command grep --color=always'  # original grep when needed
```

**Impact**: 
- Faster searches
- Respects .gitignore by default
- Better output formatting
- Fallback to original grep available

---

## 🟢 Low Priority (Nice to Have)

### 7. Add Workflow Orchestration Functions

**File:** `tools.sh`

These emerge from patterns you use repeatedly. Only add them when you've done the workflow manually enough times to know what works.

```zsh
# Web project quickstart (add when your template stabilizes)
webstart() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}webstart${NC} ${RED}<project-name>${NC}"
    return 1
  fi
  print "${BLUE}→ Creating web project${NC} ${YELLOW}$1${NC}..."
  mkdir -p "$1" && cd "$1"
  touch index.html style.css script.js
  print "${GREEN}✓ Files created${NC}"
  code .
  bss &
  print "${GREEN}✓ Running at http://localhost:3000${NC}"
}

# Git repo quickstart
gitstart() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}gitstart${NC} ${RED}<repo-name>${NC}"
    return 1
  fi
  print "${BLUE}→ Creating repository${NC} ${YELLOW}$1${NC}..."
  mkdir -p "$1" && cd "$1"
  git init
  echo "# $1" > README.md
  git add . && git commit -m "Initial commit"
  print "${GREEN}✓ Repository created${NC}"
}
```

**When to add**: After you've manually done the workflow 5+ times and the pattern is stable.

---

### 8. Practice Environment Generators

**File:** `tools.sh`

```zsh
# Git practice sandbox
gitpractice() {
  local dir="git-practice-$(date +%s)"
  mkdir "$dir" && cd "$dir"
  git init
  echo "Practice Git scenarios here" > README.md
  git add . && git commit -m "Initial practice setup"
  print "${GREEN}✓ Git practice environment ready${NC}"
}

# CSS practice sandbox
csspractice() {
  local dir="css-practice-$(date +%s)"
  mkdir "$dir" && cd "$dir"
  cat > index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body><h1>CSS Practice</h1></body>
</html>
HTML
  echo "/* Your CSS here */" > style.css
  code . && bss &
  print "${GREEN}✓ CSS practice environment ready${NC}"
}

# JavaScript practice sandbox
jspractice() {
  local dir="js-practice-$(date +%s)"
  mkdir "$dir" && cd "$dir"
  cat > index.html << 'HTML'
<!DOCTYPE html>
<html>
<head><script src="script.js"></script></head>
<body><h1>JavaScript Practice</h1></body>
</html>
HTML
  echo "// Your JavaScript here" > script.js
  code . && bss &
  print "${GREEN}✓ JavaScript practice environment ready${NC}"
}
```

**When to add**: When you find yourself creating practice environments regularly.

---

## 📋 Implementation Checklist

Copy this to track progress:

### High Priority
- [ ] alias.sh: Add cql, pips, pipu, pipl, tls, tks, tas, fd, rg
- [ ] directory-tools.sh: Add visual success feedback to sch()

### Medium Priority
- [ ] test-tools.sh: Rename split_txt → txtsplit (keep alias)
- [ ] zsh-management.sh: Add bat-extras to DevTools
- [ ] directory-tools.sh: Remove legacy tree aliases (tll, tg, to)
- [ ] tools.sh: Migrate grep to rg (add grepo fallback)

### Low Priority (When Needed)
- [ ] tools.sh: Add webstart(), gitstart() (when patterns stabilize)
- [ ] tools.sh: Add gitpractice(), csspractice(), jspractice() (when needed)

### Testing
- [ ] Test all new aliases
- [ ] Verify sch() success feedback
- [ ] Test grep → rg migration (check for issues)
- [ ] Verify bat-extras installation

---

## Philosophy Note

These quick wins follow the same principle as Phase 7 (Creative Workflow Capture):

> If you configure it twice, script it.

The difference is scope. Phase 7 captures entire workflows (music releases, ComfyUI pipelines). This checklist captures micro-frictions—missing aliases, inconsistent feedback, naming irregularities.

Both remove the same type of friction: "I have to remember how to do this."

---

## Notes

- **Backward compatibility**: Keep old function names as aliases when renaming
- **Test error states**: Verify color codes render correctly
- **Batch changes**: Group related edits for cleaner git history
- **When to add workflow functions**: Only after manual workflow is proven (5+ uses)
