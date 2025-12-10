# BRAVØ Terminal OS — Master Roadmap

## Vision

Transform any Mac into a frictionless creative workstation with unified navigation, AI-augmented workflows, and automated content pipelines.

---

## Phase 1: Provisioning Foundation ✓

**Status: COMPLETE**

Core provisioning system is fully operational.

- [x] Xcode Command Line Tools auto-installation
- [x] Homebrew installation and doctor check
- [x] CLI tools array with inline documentation
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
- [x] Unified installer functions for DRY package management

### Remaining Polish

- [x] Add missing CLI tools: `jq`, `gdu`
- [x] Remove `tree` from Programs array
- [x] Modularize package installation (Core/Tools/Media/Network/macOS/Apps)
- [ ] Add `bat-extras` to DevTools (batgrep, batman, batdiff)
- [ ] Update tree aliases in directory-tools.sh to use `eza --tree`

---

## Phase 2: Config Portability System

**Status: IN PROGRESS**

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
- [ ] Create `link_all_dotfiles()` orchestrator
- [ ] Add git config linking:
  - Create `~/.dotfiles/config/git/gitconfig`
  - Minimal `~/.gitconfig` that includes it
- [ ] Add lazygit config to dotfiles
- [ ] Add btop config to dotfiles
- [ ] Document config file locations in readme.md

---

## Phase 3: Unified J/K/L/I Navigation System

**Status: PLANNED**

Goal: Consistent spatial navigation across ALL tools. Physical key positions = logical directions.

```
      I (up)
J (left)  L (right)
      K (down)
```

### Tool Configurations Needed

- [ ] **Yazi** — File manager navigation
  - j/l = parent/child directory
  - i/k = up/down in file list
  
- [ ] **Neovim** — Editor navigation
  - Remap hjkl to jkli throughout
  - Window splits: Alt+j/l for horizontal, Alt+i/k for vertical
  - Buffer navigation with Shift variants
  
- [ ] **tmux** — Pane/window navigation
  - Pane selection: prefix + j/k/l/i
  - Pane resize: prefix + Shift + j/k/l/i
  - Window switching: prefix + Alt + j/l
  
- [ ] **lazygit** — Git TUI navigation
  - Panel switching with j/l
  - List navigation with i/k
  
- [ ] **fzf** — Fuzzy finder
  - i/k for up/down in results
  
- [ ] **Zed** — Editor (if supported)
  - Match neovim mappings where possible

### Keyboard Maestro (System-wide)

- [ ] Document J/K/L/I mappings for non-terminal apps
- [ ] Create Keyboard Maestro macro group for system navigation

---

## Phase 4: AI Project Context System

**Status: PLANNED**

Goal: Give multiple AI tools a shared whiteboard without forcing them into one schema.

### Philosophy

Each LLM works however it works. Claude uses CLAUDE.md. Codex uses AGENTS.md. Gemini has its own conventions. The system doesn't fight this—it creates a **diplomatic channel** between them.

When one LLM figures something out, you don't copy-paste it everywhere. You fold it into the shared context and tell the others: "read the notes."

- **Scratch files** = working memory (per-LLM, messy, exploratory)
- **Shared context** = curated knowledge (version controlled, deliberate)

Version control protects against breaking changes. You can experiment with what goes into CONTEXT.md, roll back if something breaks an LLM's behavior, branch for different project phases.

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

### Commands

- [ ] `aiinit` — Initialize AI context structure in current directory
- [ ] `aisync` — Interactive: select scratch content to fold into CONTEXT.md
- [ ] `aiclean` — Archive scratch files, start fresh
- [ ] `aistatus` — Show what's in scratch vs. shared context

### Workflow

1. Work with Claude on a problem. Notes accumulate in `scratch/claude.md`
2. Claude figures out something important about the architecture
3. Run `aisync`, select the relevant insight, fold it into `CONTEXT.md`
4. Switch to Codex: "Read .ai/CONTEXT.md for background"
5. Codex has the context without you copy-pasting anything

---

## Phase 5: Creative Workflow Capture

**Status: FUTURE**

Goal: When you figure out how to do something, capture it so you don't reinvent it next time.

### Philosophy

This is not "build platforms in advance." This is **incremental capture of working patterns as they emerge from real creative work**. The tooling grows by accretion, not planning.

- If you configure it twice, script it.
- If you set up a directory structure that works, templatize it.
- If you figure out a workflow, save it.

The friction being removed isn't "I have to click buttons." It's "I have to remember how I did this last time and recreate it from memory."

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

## Ethos Alignment Tasks

Quick wins to better align codebase with Minimum Viable Friction philosophy.

See [Ethos-Alignment-TODO.md](Ethos-Alignment-TODO.md) for the full checklist.

### High Priority
- [ ] Add missing short aliases (cql, pips, tls, etc.)
- [ ] Add visual feedback to `sch()`
- [ ] Add validation to `zipr()`

### Medium Priority
- [ ] Rename functions to match noun+verb pattern
- [x] Add missing CLI tools (jq, gdu) — `bat-extras` still pending
- [ ] Migrate tree aliases to eza --tree (array done, aliases pending)
- [ ] Migrate grep to rg

---

## Progress Summary

| Phase | Status | Completion |
|-------|--------|------------|
| 1. Provisioning | ✅ Complete | 98% |
| 2. Config Portability | 🔄 In Progress | 70% |
| 3. J/K/L/I Navigation | 📋 Planned | 10% |
| 4. AI Context System | 📋 Planned | 0% |
| 5. Creative Workflow Capture | 📋 Future | 0% |
