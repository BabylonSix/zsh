# BRAVO Terminal OS - Change Plan

## 0. Baseline (Verified Complete)

+ Homebrew installed and working via setupzsh()
+ ~/.dotfiles repo exists
+ ZSH is main shell
+ ~/.zshrc symlinked to ~/.dotfiles/zsh/startup.sh
+ Provisioning scripts exist (setupzsh, wipezsh, resetzsh, us)
+ Core brew tools installed via setupzsh()

---

## 1. Toolchain Gaps

[ ] Add missing modern CLI tools to setupzsh() Programs array:
    - bat-extras
    - jq
    - tldr
    - gdu

[ ] Remove legacy tools from codebase:
    - tree (still in Programs array and used in directory-tools.sh)
    - Consider removing if fully replaced by eza tree mode

---

## 2. Config Management

[ ] tmux config in dotfiles (linked via setupzsh)
[ ] yazi config in dotfiles (linked via setupzsh)
[ ] neovim config in dotfiles (linked via setupzsh)
[ ] starship config in dotfiles (linked via setupzsh)
[ ] ghostty config in dotfiles (linked via setupzsh)
[ ] zed config in dotfiles (linked via setupzsh)

[ ] Centralize git config:
    - create ~/.dotfiles/config/git/gitconfig
    - minimal ~/.gitconfig that includes it
    - add linking logic to setupzsh()

---

## 3. Provisioning Improvements

[ ] Refactor setupzsh() linking logic:
    - Extract to link_dotfile() helper function
    - Create link_all_dotfiles() orchestrator
    - Reduces repetition in setupzsh()

[*] Error formatting follows color-coded standard

---

## 4. Tool Integration

[*] tmux config in dotfiles with J/K/L/I mappings
[*] yazi installed with y() cd-on-exit function
[*] Modern tool aliases working:
    - ls -> eza (via directory-tools.sh)
    - cat -> bat (via tools.sh)
    - top -> btop (via tools.sh 'tu' alias)
    - cd -> zoxide (via tools.sh eval)

[ ] Complete tool migration:
    - grep -> rg (currently grep uses --color=always, not rg)
    - find -> fd (no fd alias exists)

[ ] Add tmux workspace launcher:
    - work() or bravo() function
    - Auto-launch configured tmux layout

---

## 5. First-Run Experience

[ ] Add setupzsh prompt to startup.sh:
    - If .dotfiles/.checkmark marker doesn't exist
    - Ask user if they want to run setupzsh
    - Exit gracefully if declined

[ ] Fix nvm version picker in us():
    - When node already at latest version
    - Should still show picker for other versions
    - Currently shows empty list if all versions installed

---

## 6. Configuration Tuning

[ ] Starship prompt customization:
    - Display [username] directory (git status)
    - Match terminal color scheme

[ ] Tool-specific keybindings (J/K/L/I pattern):
    - neovim (if not already configured)
    - yazi (if not already configured)

---

## 7. Future Enhancements

[ ] nvim custom keymap (Resolve-style: J/K/L/I, Alt, Shift, stems)
[ ] AI-CLI diff helpers (send file/block to Claude/Gemini/Codex)
[ ] BRAVO Music tmux layout (lyrics, AI, yazi, git panes)
[ ] AI-assisted refactoring of provisioning scripts
