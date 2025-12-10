# Package Organization Architecture

Modular, safe package management for setupzsh().

## Philosophy

Packages are organized by **dependency level**:

1. **Core** — System breaks without these. Never accidentally remove.
2. **Tools** — Enhance workflow. Safe to remove/reinstall.
3. **Media** — For media work. Skip if not needed.
4. **Network** — For network tasks. Skip if not needed.
5. **Apps** — GUI applications. Completely separate.

---

## Unified Installer

One function handles all package installation. Category wrappers just pass their array.

```zsh
#################
# Unified Installer
#################

installBrewPackages() {
  local category="$1"
  shift
  local packages=("$@")

  print "${BLUE}→ ${category}${NC}"
  for pkg in "${packages[@]}"; do
    if ! brew list "$pkg" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} $pkg"
      brew install "$pkg" || print "  ${RED}⚠${NC} Failed: $pkg"
    else
      print "  ${GREEN}✓${NC} $pkg"
    fi
  done
  print ""
}

installBrewCasks() {
  local category="$1"
  shift
  local apps=("$@")

  print "${BLUE}→ ${category}${NC}"
  for app in "${apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null 2>&1; then
      print "  ${YELLOW}→${NC} $app"
      brew install --cask "$app" || print "  ${RED}⚠${NC} Failed: $app"
    else
      print "  ${GREEN}✓${NC} $app"
    fi
  done
  print ""
}
```

---

## Package Categories

Each category: array definition → wrapper that calls unified installer.

```zsh
#################
# Package Lists
#################

# Core — dotfiles depend on these, don't remove
local CorePackages=(
  git                      # version control
  nvm                      # node version manager
  pyenv                    # python version manager
  zinit                    # zsh plugin manager
  fzf                      # fuzzy finder (us() pickers)
  zoxide                   # smart cd
  starship                 # prompt
  eza                      # modern ls (l, ll, la)
  trash                    # safe rm (srm)
  openssh                  # ssh tools
)

local ZshPlugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
)

# Dev tools — safe to add/remove
local DevTools=(
  bat                      # better cat
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

# Media — for audio/video work
local MediaTools=(
  ffmpeg                   # video/audio processing
  yt-dlp                   # youtube downloader
)

# Network — for network tasks
local NetworkTools=(
  httpie                   # http client
  wget                     # download tool
  rsync                    # file sync
  nmap                     # network scanner
)

# macOS utilities
local MacosTools=(
  mas                      # mac app store CLI
)

# GUI apps (casks)
local GuiApps=(
  ghostty                  # terminal
  zed                      # editor
)


#################
# Installers
#################

setupCore() {
  installBrewPackages "Core packages" "${CorePackages[@]}"
  installBrewPackages "ZSH plugins" "${ZshPlugins[@]}"
}

setupTools() { installBrewPackages "Dev tools" "${DevTools[@]}" }
setupMedia() { installBrewPackages "Media tools" "${MediaTools[@]}" }
setupNetwork() { installBrewPackages "Network tools" "${NetworkTools[@]}" }
setupMacos() { installBrewPackages "macOS utilities" "${MacosTools[@]}" }
setupApps() { installBrewCasks "GUI apps" "${GuiApps[@]}" }

setupAllPackages() {
  setupCore
  setupTools
  setupMedia
  setupNetwork
  setupMacos
  setupApps
}
```

---

## Usage

```zsh
# Full provisioning (existing behavior)
setupzsh              # Calls setupAllPackages() internally

# Selective installation
setupCore             # Just the essentials (system won't break)
setupTools            # Add dev tools
setupApps             # Add GUI apps

# Rebuild one category
setupMedia            # Reinstall after removal

# Safe removal
brew uninstall ffmpeg yt-dlp    # ✓ Safe: media tools
brew uninstall bat btop         # ✓ Safe: dev tools
brew uninstall eza              # ✗ BREAKS: l, ll, la aliases
```

---

## Benefits

| Benefit | How |
|---------|-----|
| **Safety** | Core packages clearly marked. Know what's safe to remove. |
| **Speed** | Skip categories: `setupCore && setupTools && setupApps` |
| **Clarity** | Package purpose documented inline. |
| **Maintenance** | Add packages to right category. Easy to audit. |
| **Debugging** | Something broke? Check core packages first. |
| **DRY** | One installer function. Wrappers are one-liners. |

---

## Migration Path

1. Add unified installer functions to zsh-management.sh
2. Define package arrays with inline comments
3. Add category wrappers after each array
4. Refactor setupzsh() to call `setupAllPackages()`
5. Test: `resetzsh` on a VM
6. Update readme.md with new commands

---

## Future: Interactive Mode

```zsh
setupzsh -i    # Prompt for each category

# Install core packages? (required) [Y/n]: 
# Install dev tools? [Y/n]: 
# Install media tools? [y/N]: 
# Install network tools? [y/N]: 
# Install GUI apps? [Y/n]: 
```

Skip categories during setup, not just remove after.