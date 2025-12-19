# Config Migration System - Integration Guide

## Step 1: Copy the File (30 seconds)

```bash
# Copy config-migration.sh to your dotfiles
cp config-migration.sh ~/.dotfiles/zsh/config-migration.sh
```

---

## Step 2: Update startup.sh (30 seconds)

**File:** `~/.dotfiles/zsh/startup.sh`

**Find this section (around line 30):**
```zsh
. ~/.dotfiles/zsh/zsh-management.sh        # setupzsh() and related functions
. ~/.dotfiles/zsh/path.sh                  # PATH setup (zsh-first)
. ~/.dotfiles/zsh/colors.sh                # Color variables
. ~/.dotfiles/zsh/shell.sh                 # Look & feel of the shell
```

**Add one line after colors.sh:**
```zsh
. ~/.dotfiles/zsh/zsh-management.sh        # setupzsh() and related functions
. ~/.dotfiles/zsh/path.sh                  # PATH setup (zsh-first)
. ~/.dotfiles/zsh/colors.sh                # Color variables
. ~/.dotfiles/zsh/config-migration.sh      # Config portability system
. ~/.dotfiles/zsh/shell.sh                 # Look & feel of the shell
```

---

## Step 3: Update alias.sh (30 seconds)

**File:** `~/.dotfiles/zsh/alias.sh`

**Add these aliases anywhere (suggested: after the edit aliases section):**
```zsh
# Config Migration System
alias confscan='confscan'      # scan for portable configs
alias confport='confport'      # interactive migration
alias confmove='confmove'      # move single config
alias confcheck='confcheck'    # check config status
```

---

## Step 4: Test Without Integration (2 minutes)

**Reload your shell:**
```bash
reload
```

**Test that commands work:**
```bash
# Should show function definitions
which confscan
which confport
which confmove
which confcheck
```

**Scan your current state:**
```bash
confscan
```

You should see output like:
```
Scanning for portable configs...

~/.config/ packages:
  → nvim (can be migrated)
  → yazi (can be migrated)
  ✓ tmux (in dotfiles, needs linking)

~/ dotfiles:
  → .gitconfig (can be migrated)

Found 4 config(s) that can be made portable
```

---

## Step 5: Test on One Config (5 minutes)

**Pick a non-critical config to test:**
```bash
# Examples (pick one you have):
confmove ~/.config/bat
confmove ~/.config/btop
confmove ~/.config/lazygit
```

**Verify it worked:**
```bash
# Check the command still works
bat --version    # or whatever command

# Check the symlink was created
ls -la ~/.config/bat
# Should show: bat -> /Users/bravo/.dotfiles/config/bat

# Check status
confcheck bat
# Should show: "✓ Properly managed in dotfiles"

# Check physical location
ls ~/.dotfiles/config/bat
# Should show the actual files
```

**If it works, commit it:**
```bash
cd ~/.dotfiles
git add config/bat
git commit -m "Migrate bat config to dotfiles"
```

---

## Step 6: Update setupzsh() (OPTIONAL - Do Later)

**Only do this after you've migrated your configs and tested thoroughly.**

**File:** `~/.dotfiles/zsh/zsh-management.sh`

**Find the manual linking section (around line 190):**
```zsh
  #################
  # Config Linking
  #################

  s 2
  p "${BLUE}→ Linking configs${NC}"

  [[ -d "$HOME/.dotfiles/config/nvim" ]] && \
    ln -sf "$HOME/.dotfiles/config/nvim" "$HOME/.config/nvim" && \
    p "  ${GREEN}✓${NC} nvim"

  [[ -d "$HOME/.dotfiles/config/tmux" ]] && \
    ln -sf "$HOME/.dotfiles/config/tmux" "$HOME/.config/tmux" && \
    p "  ${GREEN}✓${NC} tmux"

  # ... more manual linking ...
```

**Replace with:**
```zsh
  #################
  # Config Linking
  #################

  s 2
  conflink_all true  # Verbose mode during provisioning
```

---

## Testing Checklist

Before integrating into setupzsh(), verify:

- [ ] `reload` works without errors
- [ ] `confscan` shows your configs correctly
- [ ] `confmove` successfully migrated at least one config
- [ ] The migrated config still works (test the actual app)
- [ ] `confcheck` shows "Properly managed in dotfiles"
- [ ] Physical file exists in `~/.dotfiles/config/`
- [ ] Symlink points to correct location
- [ ] You committed the migrated config to git

---

## Usage Examples

### Daily Workflow

**New app installed:**
```bash
brew install ripgrep
# Configure it...
rg --generate config > ~/.config/ripgrep/config

# Make it portable
confscan           # See it's not portable yet
confmove ~/.config/ripgrep
git add config/ripgrep
git commit -m "Add ripgrep config"
```

**Migrate multiple configs:**
```bash
confport           # Opens fzf menu
# Tab to select configs
# Enter to migrate
```

**Check status:**
```bash
confcheck nvim       # Is nvim config portable?
confcheck tmux       # Is tmux config portable?
```

### Fresh Machine

**After running setupzsh():**
```bash
# All configs automatically linked via conflink_all()
confscan           # Should show "All configs are already portable!"
```

---

## Troubleshooting

**"Command not found: confscan"**
- Did you reload? Run: `reload`
- Check startup.sh sources config-migration.sh
- Check the file exists: `ls ~/.dotfiles/zsh/config-migration.sh`

**"Config moved but not linked"**
- Recovery command is shown in error message
- Example: `mv ~/.dotfiles/config/nvim ~/.config/nvim`

**"Symlink points to wrong location"**
- Check the case statement in `conflink_all()`
- Add your app to the appropriate section

**App doesn't work after migration**
- Check symlink: `ls -la ~/.config/appname`
- Check target exists: `ls ~/.dotfiles/config/appname`
- Try recreating symlink: `conflink_all true`

---

## What NOT to Do (Yet)

**Don't migrate these until you understand the system:**
- `.zshrc` (this is your startup.sh symlink - already managed)
- Anything in `~/.ssh/` (we'll handle this with Layer 5)
- System files in `/etc/`
- Anything you can't afford to break

**Don't integrate into setupzsh() until:**
- You've migrated at least 3-5 configs manually
- You've tested they all still work
- You're confident in the system

---

## Next Steps

**After basic testing works:**
1. Migrate your configs one at a time
2. Commit each migration to git
3. Test on a VM/docker container
4. Update setupzsh() to use conflink_all()
5. Test provisioning on fresh machine

**For now, just:**
1. Copy the file
2. Update startup.sh and alias.sh
3. Reload and test confscan
4. Migrate one non-critical config
5. Verify it works

---

## Quick Reference

| Command | What It Does |
|---------|-------------|
| `confscan` | Show which configs can be made portable |
| `confport` | Interactive migration (fzf menu) |
| `confmove <path>` | Migrate single config |
| `confcheck <name>` | Check if config is portable |
| `conflink_all` | Link all configs (used in setupzsh) |

---

That's it. Start simple, test thoroughly, migrate gradually.
