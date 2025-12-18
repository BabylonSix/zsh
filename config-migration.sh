#!/bin/zsh
#
# CONFIG MIGRATION SYSTEM
# Makes configs portable by moving them to ~/.dotfiles/config/
# and creating symlinks from their original locations
#

#################
# Known Portable Configs
#################

# Home directory dotfiles (stored without leading dot in ~/.dotfiles/config/)
typeset -ga PORTABLE_HOME_CONFIGS=(
  .gitconfig
  .gitignore_global
  .eslintrc
  .prettierrc
  .npmrc
  .yarnrc
  .tmux.conf
  .vimrc
)


#################
# Scan for Portable Configs
#################

configscan() {
  print "\n${BLUE}Scanning for portable configs...${NC}\n"

  local configs_found=0

  # Scan ~/.config/ directory
  print "${YELLOW}~/.config/ packages:${NC}"
  if [[ -d ~/.config ]]; then
    for item in ~/.config/*(N); do
      local name="${item:t}"

      # Skip if already a symlink
      [[ -L "$item" ]] && continue

      # Check if exists in dotfiles
      if [[ -e ~/.dotfiles/config/"$name" ]]; then
        print "  ${GREEN}✓${NC} $name ${BLUE}(in dotfiles, needs linking)${NC}"
      else
        print "  ${YELLOW}→${NC} $name ${BLUE}(can be migrated)${NC}"
      fi

      ((configs_found++))
    done
  fi

  # Scan home directory dotfiles
  print "\n${YELLOW}~/ dotfiles:${NC}"
  for item in $PORTABLE_HOME_CONFIGS; do
    if [[ -e ~/"$item" && ! -L ~/"$item" ]]; then
      local name="${item#.}"

      if [[ -e ~/.dotfiles/config/"$name" ]]; then
        print "  ${GREEN}✓${NC} $item ${BLUE}(in dotfiles, needs linking)${NC}"
      else
        print "  ${YELLOW}→${NC} $item ${BLUE}(can be migrated)${NC}"
      fi

      ((configs_found++))
    fi
  done

  if [[ $configs_found -eq 0 ]]; then
    print "\n${GREEN}✓ All configs are already portable!${NC}\n"
    return 0
  fi

  print "\n${BLUE}Found $configs_found config(s) that can be made portable${NC}"
  print "${BLUE}Run 'cport' for interactive migration or 'cmove <path>' for single file${NC}\n"
}


#################
# Move Single Config
#################

configmove() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}configmove${NC} ${RED}<source-path>${NC} ${YELLOW}[target-name]${NC}"
    print "\n  Examples:"
    print "    configmove ~/.config/nvim"
    print "    configmove ~/.gitconfig gitconfig"
    return 1
  fi

  local source="$1"
  local target_name="${2:-${1:t}}"

  # Remove leading dot if present
  target_name="${target_name#.}"

  # Validate source exists
  if [[ ! -e "$source" ]]; then
    print "\n${RED}ERROR:${NC} Source does not exist: $source"
    return 1
  fi

  # Check if already a symlink
  if [[ -L "$source" ]]; then
    print "\n${YELLOW}→ Already a symlink${NC}"
    print "  Source: $source"
    print "  Target: $(readlink "$source")"
    return 0
  fi

  local target="$HOME/.dotfiles/config/$target_name"

  # Check if target exists
  if [[ -e "$target" ]]; then
    print "\n${YELLOW}WARNING:${NC} Target already exists: $target"
    read "response?Overwrite? (y/n): "
    if [[ "$response" != "y" && "$response" != "Y" ]]; then
      print "Cancelled."
      return 1
    fi
    rm -rf "$target"
  fi

  # Create parent directory
  mkdir -p "$HOME/.dotfiles/config"

  print "\n${BLUE}→ Moving config to dotfiles...${NC}"
  print "  From: $source"
  print "  To:   $target"

  # Move the config
  if ! mv "$source" "$target" 2>/dev/null; then
    print "\n${RED}ERROR:${NC} Failed to move config"
    print "  Check permissions and disk space"
    return 1
  fi

  # Create symlink
  print "\n${BLUE}→ Creating symlink...${NC}"
  if ! ln -sf "$target" "$source" 2>/dev/null; then
    print "\n${RED}ERROR:${NC} Failed to create symlink"
    print "  ${YELLOW}⚠ Config moved but not linked!${NC}"
    print "  ${BLUE}→ Recovery:${NC} mv '$target' '$source'"
    return 1
  fi

  print "\n${GREEN}✓ Config migrated${NC}"
  print "  Physical: $target"
  print "  Symlink:  $source → $target\n"
}


#################
# Interactive Migration
#################

configport() {
  if ! command -v fzf &>/dev/null; then
    print "\n${RED}ERROR:${NC} fzf required for interactive mode"
    print "${BLUE}→ Install:${NC} brew install fzf\n"
    return 1
  fi

  print "\n${BLUE}╔═══════════════════════════════════╗${NC}"
  print "${BLUE}║   Config Portability System      ║${NC}"
  print "${BLUE}╚═══════════════════════════════════╝${NC}\n"

  # Build candidate list
  local -a candidates
  local -A candidate_map

  # Scan ~/.config/
  if [[ -d ~/.config ]]; then
    for item in ~/.config/*(N); do
      local name="${item:t}"

      # Skip symlinks and already-migrated configs
      [[ -L "$item" ]] && continue
      [[ -e ~/.dotfiles/config/"$name" ]] && continue

      candidates+=("$name [~/.config/$name]")
      candidate_map["$name [~/.config/$name]"]="$item"
    done
  fi

  # Scan home dotfiles
  for item in $PORTABLE_HOME_CONFIGS; do
    if [[ -e ~/"$item" && ! -L ~/"$item" ]]; then
      local display_name="${item#.} [~/$item]"

      # Skip already-migrated
      [[ -e ~/.dotfiles/config/"${item#.}" ]] && continue

      candidates+=("$display_name")
      candidate_map["$display_name"]=~/"$item"
    fi
  done

  if [[ ${#candidates[@]} -eq 0 ]]; then
    print "${GREEN}✓ All configs are already portable!${NC}\n"
    return 0
  fi

  print "${BLUE}Select configs to migrate:${NC}"
  print "  ${YELLOW}Tab${NC}   = select/deselect"
  print "  ${YELLOW}Enter${NC} = confirm"
  print "  ${YELLOW}Esc${NC}   = cancel\n"

  # Multi-select with fzf
  local selected=$(printf '%s\n' "${candidates[@]}" \
    | fzf --multi \
          --height=20 \
          --reverse \
          --prompt="Config > " \
          --header="Select configs to migrate")

  if [[ -z "$selected" ]]; then
    print "\n${YELLOW}→ No configs selected${NC}\n"
    return 0
  fi

  # Process selections
  print "\n${BLUE}→ Migrating selected configs...${NC}\n"

  local count=0
  while IFS= read -r line; do
    local source="${candidate_map[$line]}"

    if [[ -n "$source" ]]; then
      ((count++))
      configmove "$source"
    fi
  done <<< "$selected"

  print "${GREEN}✓ Migrated $count config(s)${NC}\n"
}


#################
# Check Config Status
#################

configcheck() {
  if [[ -z "$1" ]]; then
    print "\n${RED}ERROR:${NC}"
    print "\n  ${GREEN}configcheck${NC} ${RED}<config-name>${NC}"
    print "\n  Example: configcheck nvim"
    return 1
  fi

  local name="${1#.}"
  local config_path=""

  # Find config location
  if [[ -e ~/.config/"$1" ]]; then
    config_path=~/.config/"$1"
  elif [[ -e ~/."$1" ]]; then
    config_path=~/."$1"
  else
    print "\n${RED}ERROR:${NC} Config not found: $1"
    return 1
  fi

  print "\n${BLUE}Config:${NC} $1"
  print "  Location: $config_path"

  if [[ -L "$config_path" ]]; then
    local target=$(readlink "$config_path")
    print "  Status:   ${GREEN}Portable (symlinked)${NC}"
    print "  Target:   $target"

    if [[ "$target" == *".dotfiles/config"* ]]; then
      print "  ${GREEN}✓ Properly managed in dotfiles${NC}\n"
      return 0
    else
      print "  ${YELLOW}⚠ Symlinked but not in dotfiles${NC}\n"
      return 1
    fi
  else
    print "  Status:   ${YELLOW}Not portable (physical file)${NC}"
    print "  ${BLUE}→ Run:${NC} configmove $config_path\n"
    return 1
  fi
}


#################
# Bulk Auto-Linking (for setupzsh)
#################

configlink_all() {
  local verbose="${1:-false}"

  print "${BLUE}→ Linking portable configs...${NC}"

  local linked=0
  local skipped=0

  if [[ -d ~/.dotfiles/config ]]; then
    for item in ~/.dotfiles/config/*(N); do
      local name="${item:t}"
      local target=""

      # Determine target location
      case "$name" in
        # Modern apps → ~/.config/
        nvim|tmux|yazi|zed|ghostty|starship.toml|lazygit|btop|bat)
          target=~/.config/"$name"
          ;;
        # Legacy dotfiles → ~/ with leading dot
        gitconfig|gitignore_global|eslintrc|prettierrc|npmrc|yarnrc|vimrc|tmux.conf)
          target=~/."$name"
          ;;
        *)
          # Default to ~/.config/
          target=~/.config/"$name"
          ;;
      esac

      # Skip if already correctly linked
      if [[ -L "$target" && "$(readlink "$target")" == "$item" ]]; then
        ((skipped++))
        [[ "$verbose" == "true" ]] && print "  ${BLUE}→${NC} $name ${BLUE}(already linked)${NC}"
        continue
      fi

      # Remove existing file/symlink
      if [[ -e "$target" || -L "$target" ]]; then
        rm -rf "$target"
      fi

      # Create parent directory
      local parent="${target:h}"
      mkdir -p "$parent"

      # Create symlink
      ln -sf "$item" "$target"
      print "  ${GREEN}✓${NC} $name → $(echo "$target" | sed "s|$HOME|~|")"
      ((linked++))
    done
  fi

  # Summary
  if [[ $linked -eq 0 ]]; then
    print "  ${GREEN}✓${NC} All configs already linked"
    [[ "$verbose" == "true" && $skipped -gt 0 ]] && print "  ${BLUE}→${NC} Skipped $skipped config(s)"
  else
    print "  ${GREEN}✓${NC} Linked $linked config(s)"
    [[ "$verbose" == "true" && $skipped -gt 0 ]] && print "  ${BLUE}→${NC} Skipped $skipped config(s)"
  fi
}
