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
