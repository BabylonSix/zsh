# Ethos Alignment — Quick Wins

Tactical improvements to better align the codebase with **Minimum Viable Friction Development**.

> These are small, focused changes that can be knocked out in a single session.
> Each one removes a paper cut. Collectively, they compound into flow state.

---

## ✅ Completed

### Error Handling (Error States as Learning)

- [x] `v()` — Disk volume selector with available volumes list
- [x] `sch()` — Basic error handling (missing visual feedback)
- [x] `md()` — Directory creation with error handling
- [x] `cho()` — Ownership change with syntax feedback

### Provisioning

- [x] First-run detection with interactive prompt
- [x] `us()` with fzf version pickers for Node/Python
- [x] Color-coded progress throughout setupzsh()
- [x] Package modularization (Core/Tools/Media/Network/macOS/Apps)
- [x] Unified installer functions (`installBrewPackages`, `installBrewCasks`)

### Modern Tool Integration

- [x] `cat` → `bat` alias
- [x] `ls` → `eza` aliases (l, ll, la, lla, lh, lm)
- [x] `top` → `btop` via `tu` alias
- [x] `cd` → `zoxide` integration
- [x] `y()` for yazi with cd-on-exit

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

# Modern tool shortcuts
alias fd='fd'     # already installed, ensure accessible
alias rg='rg'     # already installed via ripgrep
```

### 2. Add Visual Feedback to sch()

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

### 3. Add Validation to zipr()

**File:** `directory-tools.sh`

Current `zipr()` has no error handling.

```zsh
zipr() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}zipr${NC} ${RED}<file-or-directory>${NC}"
    return 1
  fi
  if [[ ! -e "$1" ]]; then
    print "\n${RED}ERROR:${NC} '$1' does not exist"
    return 1
  fi
  print "${BLUE}→ Compressing${NC} ${YELLOW}$1${NC}..."
  zip -r "$1.zip" "$1"
  print "${GREEN}✓ Created $1.zip${NC}"
}
```

---

## 🟡 Medium Priority (Consistency)

### 4. Rename Functions to Match Patterns

**Manual terminal commands should use lowercase noun+verb:**

| Current | Rename To | Reason |
|---------|-----------|--------|
| `split_txt()` | `txtsplit()` | noun+verb: txt+split |
| `new-git()` | `gitcreate()` | noun+verb: git+create |

### 5. Add Missing CLI Tools

**File:** `zsh-management.sh` DevTools array

- [x] `jq` — JSON processor (added)
- [x] `gdu` — disk usage analyzer (added)
- [ ] `bat-extras` — batgrep, batman, batdiff, etc.

### 6. Migrate tree to eza --tree

**File:** `zsh-management.sh`
- [x] Remove `tree` from Programs array

**File:** `directory-tools.sh`
- [ ] Replace tree aliases with eza equivalents:

```zsh
# Directory tree (using eza)
alias t='eza --tree --level=2 -I "node_modules|.git"'
alias t2='eza --tree --level=2 -I "node_modules|.git"'
alias t3='eza --tree --level=3 -I "node_modules|.git"'
alias t4='eza --tree --level=4 -I "node_modules|.git"'
alias t5='eza --tree --level=5 -I "node_modules|.git"'
alias ta='eza --tree --level=2 -a -I "node_modules|.git"'
```

### 7. Migrate grep to rg

**File:** `tools.sh`

Change from:
```zsh
alias grep='grep --color=always'
```

To:
```zsh
# Use ripgrep as default (faster, respects .gitignore)
alias grep='rg'
alias grepo='command grep --color=always'  # original grep when needed
```

---

## 🟢 Low Priority (Nice to Have)

### 8. Add Workflow Orchestration Functions

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

### 9. Practice Environment Generators

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
  cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><link rel="stylesheet" href="style.css"></head>
<body><h1>CSS Practice</h1></body>
</html>
EOF
  echo "/* Your CSS here */" > style.css
  code . && bss &
  print "${GREEN}✓ CSS practice environment ready${NC}"
}
```

---

## Implementation Checklist

Copy this to track progress:

```
[ ] alias.sh: Add cql, pips, pipu, pipl, tls, tks, tas
[ ] directory-tools.sh: Add visual feedback to sch()
[ ] directory-tools.sh: Add validation to zipr()
[ ] test-tools.sh: Rename split_txt → txtsplit
[ ] git.sh: Rename new-git → gitcreate
[x] zsh-management.sh: Add jq, gdu to DevTools
[ ] zsh-management.sh: Add bat-extras to DevTools
[x] zsh-management.sh: Remove tree from Programs
[x] zsh-management.sh: Modularize package arrays
[ ] directory-tools.sh: Replace tree aliases with eza --tree
[ ] tools.sh: Change grep alias to rg
[ ] tools.sh: Add webstart(), gitstart() (when ready)
[ ] tools.sh: Add gitpractice(), csspractice() (when ready)
[ ] Test all changes
[ ] Update readme.md
```

---

## Philosophy Note

These quick wins follow the same principle as Phase 5 (Creative Workflow Capture):

> If you configure it twice, script it.

The difference is scope. Phase 5 captures entire workflows (music releases, ComfyUI pipelines). This checklist captures micro-frictions—missing aliases, inconsistent feedback, naming irregularities.

Both remove the same type of friction: "I have to remember how to do this."

---

## Notes

- **Backward compatibility**: Keep old function names as aliases when renaming
- **Test error states**: Verify color codes render correctly
- **Batch changes**: Group related edits for cleaner git history
