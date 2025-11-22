# BRAVØ Terminal OS – Change Plan

## 0. Baseline (already true)

+ Homebrew is installed and working  
+ `~/.dotfiles` repo exists and is under git  
+ ZSH is your main shell  
+ `.zshrc` already sources a startup.sh (or equivalent) from `~/.dotfiles/zsh/`  
+ Existing provisioning scripts exist (`setupzsh`, `resetzsh`, `us()`, etc.)  
+ Existing `~/.tmux.conf` is working with your current Resolve-style mappings  
+ Core brew tools already present (tmux, neovim, git, zsh, bash, ffmpeg, postgres, etc.)

---

## 1. Toolchain – install/verify modern CLI stack

[*] Ensure modern navigation / search tools are installed via brew  
    - yazi  
    - zoxide  
    - fzf  
    - eza  
    - bat  
    - bat-extras  
    - ripgrep  
    - fd  
    - jq  
    - btop  
    - tldr  
    - gdu  

[*] Remove / de-emphasize legacy tools  
    - stop relying on `tree`  
    - stop relying on `ack`  
    - stop relying on `nano` / `emacs`  
    - stop using `screen`

[*] Confirm older infra tools you *do* keep are present  
    - gzip / bzip2 / xz / unzip  
    - openssh  
    - watch  

---

## 2. Dotfiles layout – move configs into `~/.dotfiles` + symlink

[*] Move tmux config into dotfiles and symlink  
    - create `~/.dotfiles/tmux/`  
    - move `~/.tmux.conf` → `~/.dotfiles/tmux/tmux.conf`  
    - `ln -s ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf`

[ ] Move yazi config into dotfiles and symlink  
    - create `~/.dotfiles/yazi/`  
    - move `~/.config/yazi/*` → `~/.dotfiles/yazi/`  
    - `ln -s ~/.dotfiles/yazi ~/.config/yazi`

[ ] Move neovim config into dotfiles and symlink  
    - create `~/.dotfiles/nvim/`  
    - move `~/.config/nvim/*` → `~/.dotfiles/nvim/`  
    - `ln -s ~/.dotfiles/nvim ~/.config/nvim`

[ ] Centralize git config  
    - create `~/.dotfiles/git/gitconfig`  
    - write minimal `~/.gitconfig` that includes it

---

## 3. ZSH + provisioning – make the environment portable

[ ] Add a `link_dotfile()` helper in `~/.dotfiles/zsh/tools.sh`  
[ ] Add a full `link_all_dotfiles()` that links tmux, yazi, nvim, gitconfig  
[ ] Call `link_all_dotfiles()` inside `setupzsh`  
[ ] Add an `install_tools()` / `update_tools()` helper (brew update, install, cleanup)  
[ ] Update `us()` to call `update_tools()`  
[ ] Ensure error formatting follows your color-coded self-teaching standard  

---

## 4. tmux / yazi / tool integration – workflow layer

[*] Confirm tmux north-star config lives fully in `~/.dotfiles/tmux/tmux.conf`  
    - J/K/L/I pane nav  
    - Alt + J/K/L/I resize  
    - N / n / m / g window verbs  
    - `,` / `.` window navigation  
    - base-index 1  

[ ] Add a wrapper function (e.g. `work()` or `bravo()`) to auto-launch your tmux workspace  
[ ] Integrate yazi as a first-class tool (alias or tmux key to open it)  
[ ] Begin replacing:  
    - `ls` → `eza`  
    - `cat` → `bat`  
    - `grep` → `rg`  
    - `find` → `fd`  
    - `top/htop` → `btop`  
    - `cd` → `zoxide`  

---

## 5. Future / optional layers

[ ] nvim custom keymap (Resolve-style: J/K/L/I, Alt, Shift, stems)  
[ ] Add AI-CLI diff helpers (send file or block to Claude/Gemini/Codex)  
[ ] Build BRAVØ Music tmux layout (lyrics pane, AI pane, yazi pane, git pane)  
[ ] Gradually refactor provisioning (`us()`, setup scripts) using AI agents
