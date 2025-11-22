# Ethos Alignment TODO

This document outlines improvements to better align the codebase with the **Minimum Viable Friction Development** ethos.

## High Priority (Violates Core Ethos)

### 1. Add Missing Aliases (Single Command Philosophy)
**File:** `alias.sh`

Add these missing short aliases (using consonant compression to avoid system conflicts):
```zsh
alias stst='screenTest'    # screen test (avoid st conflict with Suckless Terminal)
alias psz='photosize'      # photo size (consonant compression)
alias cql='cleanQl'        # clean QuickLook
```

**Note**: Don't create aliases for camelCase functions like `charCount`, `disableOutput`, `enableOutput` - these are script/programmatic functions that should self-document, not optimize for typing efficiency.

### 2. Fix Error Handling (Error States as Learning)
**File:** `directory-tools.sh`

**Fix v() function:**
```zsh
v() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  You did not enter a Disk Volume"
    print "\n  ${GREEN}v${NC} ${RED}<volume-name>${NC}"
    print "\n  Available volumes:"
    ls /Volumes/
  else
    cd /Volumes/$1
  fi
}
```

**Add error handling to sch():**
```zsh
sch() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  Directory path missing"
    print "\n  ${GREEN}sch${NC} ${RED}<directory-path>${NC}"
    return 1
  fi
  print "${BLUE}Taking ownership of${NC} ${YELLOW}$1${NC}"
  sudo chown -R $(whoami):admin "$1"
  print "${GREEN}✓ Ownership changed${NC}"
}
```

**Add validation to zipr():**
```zsh
zipr() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  File/directory name missing"
    print "\n  ${GREEN}zipr${NC} ${RED}<file-or-directory>${NC}"
    return 1
  fi
  if [[ ! -e $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  File/directory '$1' does not exist"
    return 1
  fi
  print "${BLUE}Compressing${NC} ${YELLOW}$1${NC}..."
  zip -r $1.zip $1
  print "${GREEN}✓ Created $1.zip${NC}"
}
```

### 3. Add Workflow Orchestration
**File:** `tools.sh`

**New web project workflow:**
```zsh
webcreate() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  Project name missing"
    print "\n  ${GREEN}webcreate${NC} ${RED}<project-name>${NC}"
    return 1
  fi
  print "${BLUE}Creating web project${NC} ${YELLOW}$1${NC}..."
  mkdir $1 && cd $1
  touch index.html style.css script.js
  print "${GREEN}✓ Files created${NC}"
  code .
  bss &
  print "${GREEN}✓ Web project '$1' running at http://localhost:3000${NC}"
}
```

**Git new repo workflow:**
```zsh
gitcreate() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  Repository name missing"
    print "\n  ${GREEN}gitcreate${NC} ${RED}<repo-name>${NC}"
    return 1
  fi
  print "${BLUE}Creating git repository${NC} ${YELLOW}$1${NC}..."
  mkdir $1 && cd $1
  git init
  touch README.md
  echo "# $1" > README.md
  git add .
  git commit -m "Initial commit"
  print "${GREEN}✓ Repository '$1' created${NC}"
}
```

## Medium Priority (Consistency Improvements)

### 4. Standardize Naming Patterns
**Files:** `directory-tools.sh`, `tools.sh`, `test-tools.sh`

**Rename following usage context and noun+verb patterns:**

**Manual terminal commands (lowercase compound with noun+verb):**
- `resize-photos()` → `photoresize()` (noun+verb: photo+resize)
- `photo-sizes()` → `photosize()` (noun+verb: photo+size)
- `split_txt()` → `txtsplit()` (noun+verb: txt+split)
- `new-git()` → `gitcreate()` (noun+verb: git+create)

**Keep camelCase for script/programmatic functions:**
- `screenSize()` - unchanged (used in scripts)
- `charCount()` - unchanged (used in scripts)
- `disableOutput()` - unchanged (used in scripts)

### 5. Add Tool+Action Fusion for Package Managers
**File:** `alias.sh`

**Python shortcuts:**
```zsh
# Python package management
alias pips='pip3 install'     # pip save
alias pipl='pip3 list'        # pip list
alias pipo='pip3 show'        # pip options/info
alias pipu='pip3 install -U'  # pip upgrade
```

**Conda shortcuts (using consonant compression to avoid CAS conflicts):**
```zsh
# Conda environment management
alias cact='conda activate'    # conda activate (avoid cas conflict)
alias cdct='conda deactivate'  # conda deactivate (avoid cad conflict)
alias clst='conda list'        # conda list (consonant compression)
alias cinst='conda install'    # conda install (consonant compression)
alias cenv='conda env list'    # conda environments (consonant compression)
```

**Homebrew shortcuts (using consonant compression where needed):**
```zsh
# Homebrew management
alias blst='brew list'        # brew list (consonant compression, avoid bl conflicts)
alias bsrch='brew search'     # brew search (consonant compression, avoid bs conflict)
alias binf='brew info'        # brew info (consonant compression)
```

**Tmux shortcuts:**
```zsh
# Tmux session management
alias tls='tmux list-sessions'  # tmux list
alias tks='tmux kill-session'   # tmux kill
alias tas='tmux attach-session' # tmux attach
```

### 6. Add Visual Feedback to Silent Functions
**File:** `tools.sh`

**Improve cho() function:**
```zsh
cho() {
  if [[ -z $1 ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  Owner specification missing"
    print "\n  ${GREEN}cho${NC} ${RED}<owner>${NC}"
    return 1
  fi
  print "${BLUE}Changing ownership to${NC} ${YELLOW}$1${NC}"
  chown $1
  print "${GREEN}✓ Ownership changed${NC}"
}
```

### 7. Add Progress Indicators
**File:** `tools.sh`

**Add progress bars to us() function:**
```zsh
us() {
  print "${BLUE}System Update Started${NC}\n"
  
  print "${BLUE}[1/4] Updating Homebrew...${NC}"
  brew update && brew upgrade
  print "${GREEN}✓ Homebrew updated${NC}\n"
  
  print "${BLUE}[2/4] Updating Node.js...${NC}"
  nvmup
  print "${GREEN}✓ Node.js updated${NC}\n"
  
  print "${BLUE}[3/4] Updating NPM packages...${NC}"
  npm update -g && npm upgrade -g
  print "${GREEN}✓ NPM packages updated${NC}\n"
  
  print "${BLUE}[4/4] System cleanup...${NC}"
  if [[ -a ~/.npmrc ]]; then rm ~/.npmrc; fi
  print "${GREEN}✓ System cleanup complete${NC}\n"
  
  print "${GREEN}✓ All systems updated successfully${NC}"
}
```

## Low Priority (Nice to Have)

### 8. Add Deliberate Practice Functions
**File:** `tools.sh`

Following the established noun+verb pattern for manual terminal commands:
```zsh
# Practice environments (noun+verb: git+practice, css+practice, js+practice)
gitpractice() {
  mkdir git-practice-$(date +%s) && cd $_
  git init
  echo "Practice Git scenarios here" > README.md
  git add . && git commit -m "Initial practice setup"
  print "${GREEN}✓ Git practice environment ready${NC}"
}

csspractice() {
  mkdir css-practice-$(date +%s) && cd $_
  echo "<!DOCTYPE html><html><head><link rel='stylesheet' href='style.css'></head><body><h1>CSS Practice</h1></body></html>" > index.html
  echo "/* Your CSS practice here */" > style.css
  code .
  bss &
  print "${GREEN}✓ CSS practice environment ready${NC}"
}

jspractice() {
  mkdir js-practice-$(date +%s) && cd $_
  echo "<!DOCTYPE html><html><head><script src='script.js'></script></head><body><h1>JavaScript Practice</h1></body></html>" > index.html
  echo "// Your JavaScript practice here" > script.js
  code .
  bss &
  print "${GREEN}✓ JavaScript practice environment ready${NC}"
}
```

## Implementation Notes

- **Maintain backward compatibility**: Keep existing function names as aliases
- **Test error states**: Verify error messages display correctly with colors
- **Update CLAUDE.md**: Document new patterns after implementation
- **Follow established conventions**: Use existing color variables and formatting
- **Batch related changes**: Group similar improvements for easier testing

## Completion Checklist

- [ ] Add missing aliases to `alias.sh`
- [ ] Fix error handling in `directory-tools.sh`
- [ ] Add workflow orchestration functions to `tools.sh`
- [ ] Rename functions to follow naming patterns
- [ ] Add package manager shortcuts
- [ ] Add visual feedback to silent functions
- [ ] Implement progress indicators
- [ ] Add deliberate practice functions
- [ ] Update documentation
- [ ] Test all changes