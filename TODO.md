# BRAVØ Terminal OS — Master Roadmap

## Vision

Transform any Mac into a frictionless creative workstation with unified navigation, AI-augmented workflows, and automated content pipelines.

---

## Phase 1: Provisioning Foundation ✅

**Status: COMPLETE (98%)**

Core provisioning system is fully operational.

### Completed ✓

- [x] Xcode Command Line Tools auto-installation
- [x] Homebrew installation and doctor check
- [x] CLI tools with inline documentation
- [x] ZSH plugins (syntax-highlighting, autosuggestions, F-Sy-H)
- [x] GUI apps via casks (Ghostty, Zed)
- [x] Node.js via NVM with version management
- [x] Python via pyenv with version management
- [x] First-run detection with `.✓` marker
- [x] Interactive bootstrap prompt in startup.sh
- [x] `setupzsh()` — provision from zero
- [x] `wipezsh()` — clean removal
- [x] `resetzsh()` — fresh start
- [x] `upgradezsh()` — update ZSH version
- [x] `us()` — universal system update with fzf version pickers
- [x] Modular package system (Core/Tools/Media/Network/macOS/Apps)
- [x] Unified installer functions (installBrewPackages, installBrewCasks)
- [x] Selective installers (setupCore, setupTools, setupMedia, etc.)
- [x] Remove `tree` from package arrays (replaced by eza --tree)
- [x] Add `jq`, `gdu`, `tldr` to DevTools

### Remaining Polish

- [ ] Add `bat-extras` to DevTools (batgrep, batman, batdiff, prettybat)
  - File: `zsh-management.sh` DevTools array
  - Action: Add to array with inline comment

---

## Phase 2: Architectural Improvements ✅

**Status: COMPLETE (95%)**

Major code quality and architecture improvements.

### Completed ✓

- [x] **Functions Over Aliases** — Complete refactor for composability
  - directory-tools.sh: f(), d(), lns(), o(), of(), od(), srm()
  - ssh.sh: sshl(), ssha()
  - All functions now support proper argument passthrough via `"$@"`
  
- [x] **Tree Migration to Eza**
  - Function: `tree() { eza --tree --color=always -I ".git|node_modules" "$@"; }`
  - Depth aliases: t2-t9 working
  - Legacy aliases removed from Programs array

- [x] **Git Functions Refactor**
  - Organized into sections (Status, Staging, Commits, Branches, Diffs, Remotes, Stash)
  - All functions properly quote arguments
  - Better error handling with visual feedback
  - Removed deprecated aliases

- [x] **Node Tools Cleanup**
  - Removed dependency on external `revolver` tool
  - Simplified `nvmup()` logic
  - Better error handling throughout

- [x] **Error Handling** — Visual, educational error pattern
  - v() — disk volume selector with available volumes list
  - sch() — ownership change with error handling
  - md() — directory creation with validation
  - cho() — ownership change with syntax feedback
  - zipr() — zip with validation

- [x] **Modern Tool Integration**
  - cat → bat
  - ls → eza (l, ll, la, lla, lh, lm)
  - tree → eza --tree
  - top → btop
  - cd → zoxide
  - y() for yazi with cd-on-exit

### Remaining Polish

- [ ] Add visual success feedback to sch()
  - Currently has error handling but no "✓ Ownership changed" message
  - File: `directory-tools.sh`

- [ ] Clean up remaining tree aliases
  - File: `directory-tools.sh`
  - Remove: tll, tg, to legacy aliases
  - Already removed: ta, tlla (done in current version)

---

## Phase 3: Config Portability System 📋

**Status: IN PROGRESS (70%)**

Goal: All tool configurations live in `~/.dotfiles/config/` and get symlinked automatically.

### Current Config Linking (in setupzsh)

- [x] nvim → `~/.config/nvim`
- [x] tmux → `~/.config/tmux`
- [x] starship.toml → `~/.config/starship.toml`
- [x] zed → `~/.config/zed`
- [x] ghostty → `~/Library/Application Support/com.mitchellh.ghostty`
- [x] yazi → `~/.config/yazi`

### Needed

- [ ] Create `link_dotfile()` helper function for DRY linking
  - File: `zsh-management.sh`
  - Reduces repetition in setupzsh()
  
- [ ] Create `link_all_dotfiles()` orchestrator
  - File: `zsh-management.sh`
  - Calls link_dotfile() for each config

- [ ] Centralize git config
  - Create `~/.dotfiles/config/git/gitconfig`
  - Minimal `~/.gitconfig` that includes it
  - Add linking logic to setupzsh()

- [ ] Add lazygit config to dotfiles
  - Location: `~/.dotfiles/config/lazygit/`
  - Link to: `~/.config/lazygit/`

- [ ] Add btop config to dotfiles
  - Location: `~/.dotfiles/config/btop/`
  - Link to: `~/.config/btop/`

- [ ] Document config file locations in readme.md

---

## Phase 4: Ethos Alignment — Quick Wins 📋

**Status: IN PROGRESS (40%)**

Small, focused changes that remove paper cuts.

### High Priority

- [ ] Add missing short aliases
  - File: `alias.sh`
  - Add: cql, pips, pipu, pipl, tls, tks, tas
  - Add: fd, rg (ensure accessible)

- [ ] Rename functions to match noun+verb pattern
  - File: `test-tools.sh`
  - `split_txt()` → `txtsplit()`
  - Keep old name as alias for backward compatibility
  
- [ ] Rename git function to match pattern
  - File: `git.sh`
  - `gitnew()` already follows pattern (was new-git in old version)
  - No action needed ✓

### Medium Priority

- [ ] Migrate grep to rg
  - File: `tools.sh`
  - Change: `alias grep='grep --color=always'` → `alias grep='rg'`
  - Add: `alias grepo='command grep --color=always'` (original grep when needed)

- [ ] Add workflow orchestration functions (when patterns stabilize)
  - File: `tools.sh`
  - Examples: webstart(), gitstart() (only add after manual workflow is proven)

### Low Priority (Future)

- [ ] Add deliberate practice functions
  - File: `tools.sh`
  - Examples: gitpractice(), csspractice(), jspractice()
  - Only add when you've used the manual workflow enough to know what works

---

## Phase 5: Unified J/K/L/I Navigation System 📋

**Status: PLANNED (10%)**

Goal: Consistent spatial navigation across ALL tools. Physical key positions = logical directions.

```
      I (up)
J (left)  L (right)
      K (down)
```

### Tool Configurations Needed

- [ ] **tmux** — Already configured with J/K/L/I (✓)
  - Verify: pane selection, resizing, window switching

- [ ] **Yazi** — File manager navigation
  - j/l = parent/child directory
  - i/k = up/down in file list
  - Config location: `~/.dotfiles/config/yazi/`

- [ ] **Neovim** — Editor navigation
  - Remap hjkl to jkli throughout
  - Window splits: Alt+j/l for horizontal, Alt+i/k for vertical
  - Buffer navigation with Shift variants
  - Config location: `~/.dotfiles/config/nvim/`

- [ ] **lazygit** — Git TUI navigation
  - Panel switching with j/l
  - List navigation with i/k
  - Config location: `~/.dotfiles/config/lazygit/`

- [ ] **fzf** — Fuzzy finder
  - i/k for up/down in results
  - Config: shell.sh or fzf config file

- [ ] **Zed** — Editor (if supported)
  - Match neovim mappings where possible
  - Config location: `~/.dotfiles/config/zed/`

### Keyboard Maestro (System-wide)

- [ ] Document J/K/L/I mappings for non-terminal apps
- [ ] Create Keyboard Maestro macro group for system navigation
- [ ] DaVinci Resolve integration example

---

## Phase 6: AI Project Context System 📋

**Status: PLANNED (0%)**

Goal: Give multiple AI tools a shared whiteboard without forcing them into one schema.

### Philosophy

Each LLM works however it works. Claude uses CLAUDE.md. Codex uses AGENTS.md. Gemini has its own conventions. The system creates a **diplomatic channel** between them.

When one LLM figures something out, fold it into shared context. Others read the notes.

- **Scratch files** = working memory (per-LLM, messy, exploratory)
- **Shared context** = curated knowledge (version controlled, deliberate)

### Architecture

```
project/
├── .ai/
│   ├── CONTEXT.md          # Shared context (curated, version controlled)
│   ├── claude/
│   │   └── CLAUDE.md       # Claude-specific instructions
│   ├── codex/
│   │   └── AGENTS.md       # Codex agent definitions
│   ├── gemini/
│   │   └── GEMINI.md       # Gemini-specific context
│   └── scratch/
│       ├── claude.md       # Claude working notes
│       ├── codex.md        # Codex working notes
│       └── gemini.md       # Gemini working notes
└── ...project files
```

### Commands to Build

- [ ] `aiinit` — Initialize AI context structure in current directory
- [ ] `aisync` — Interactive: select scratch content to fold into CONTEXT.md
- [ ] `aiclean` — Archive scratch files, start fresh
- [ ] `aistatus` — Show what's in scratch vs. shared context

### Workflow Example

1. Work with Claude on a problem. Notes accumulate in `scratch/claude.md`
2. Claude figures out something important about the architecture
3. Run `aisync`, select the relevant insight, fold it into `CONTEXT.md`
4. Switch to Codex: "Read .ai/CONTEXT.md for background"
5. Codex has the context without copy-pasting anything

---

## Phase 7: Creative Workflow Capture 📋

**Status: FUTURE (0%)**

Goal: When you figure out how to do something, capture it so you don't reinvent it next time.

### Philosophy

This is not "build platforms in advance." This is **incremental capture of working patterns as they emerge from real creative work**. The tooling grows by accretion, not planning.

- If you configure it twice, script it.
- If you set up a directory structure that works, templatize it.
- If you figure out a workflow, save it.

### Capture Areas (as needed)

**Web Projects**
- [ ] `webinit <name>` — Scaffold from working template (when you have one)
- [ ] Capture build/deploy patterns as they stabilize

**n8n Workflows**
- [ ] `n8nexport` — Save current workflow to dotfiles
- [ ] `n8nimport` — Restore workflow from repo

**ComfyUI Pipelines**
- [ ] `comfysave` — Save working workflow to dotfiles
- [ ] `comfyload <name>` — Load saved workflow

**Music Releases**
- [ ] `songinit <title>` — Create project structure (captured from first successful release)
  ```
  songs/<title>/
  ├── stems/
  ├── masters/
  ├── artwork/
  ├── metadata.yaml
  └── releases/
      ├── spotify/
      ├── apple-music/
      ├── youtube-music/
      ├── tiktok/
      └── content-id/
  ```
- [ ] `songrelease` — Generate platform packages (as you learn each platform's requirements)

### Implementation Approach

1. Do the creative work manually
2. Notice what structure/workflow worked
3. Capture it as a script/template
4. Refine through repeated use
5. Version control protects against regressions

---

## Progress Summary

| Phase | Status | Completion | Priority |
|-------|--------|------------|----------|
| 1. Provisioning Foundation | ✅ Complete | 98% | — |
| 2. Architectural Improvements | ✅ Complete | 95% | — |
| 3. Config Portability | 📋 In Progress | 70% | High |
| 4. Ethos Alignment Quick Wins | 📋 In Progress | 40% | High |
| 5. J/K/L/I Navigation | 📋 Planned | 10% | Medium |
| 6. AI Context System | 📋 Planned | 0% | Low |
| 7. Creative Workflow Capture | 📋 Future | 0% | Low |

---

## Next Actions

### Immediate (This Week)
1. Add bat-extras to DevTools
2. Add visual feedback to sch()
3. Add missing aliases (cql, pips, tls, etc.)
4. Clean up remaining tree aliases

### Short Term (This Month)
1. Create link_dotfile() helper
2. Centralize git config
3. Add lazygit and btop configs
4. Migrate grep to rg

### Medium Term (Next Quarter)
1. Yazi J/K/L/I configuration
2. Neovim J/K/L/I configuration  
3. lazygit J/K/L/I configuration
4. Document Keyboard Maestro mappings

### Long Term (When Needed)
1. AI Context System (when working with multiple LLMs becomes routine)
2. Creative Workflow Capture (as patterns emerge from actual work)
