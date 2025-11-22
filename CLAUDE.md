# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with this ZSH dotfiles repository.

## System Philosophy: Minimum Viable Friction Development

This is a personal productivity system optimized for learning velocity and workflow automation. Core principles:

- **Single Command Philosophy**: Complex operations reduce to one keystroke/command
- **Automate Cognitive Load**: If you think about it twice, script it
- **Eliminate Context Switching**: Remove anything that breaks flow state
- **Instant Environment Recovery**: Any machine becomes "your machine" in one command
- **Pattern-Based Discoverability**: Systems are intuitive through consistent mental models
- **Error States as Learning**: Failures teach correct usage through visual, contextual feedback
- **Deliberate Practice Infrastructure**: Automate practice environment creation to focus on skill building

## Architecture Overview

### Single-Command Provisioning System
- `setupzsh()`: Complete development environment from zero to productive
- `uninstallzsh()`: Clean removal for temporary machines (leave no trace)
- `resetzsh()`: Fresh start (uninstall + setup)

The goal: Deploy personal development environment on any Mac with one command, remove it completely when done.

### Self-Documenting Package Management
Key arrays with inline documentation:
- `Programs[]` in `setup.sh:42-90` - 90+ Homebrew packages with purpose comments
- `Utils[]` in `setup.sh:110-123` - GNU utilities with explanations  
- `npmPackages[]` in `node-setup.sh:14-61` - Node.js packages for development

These serve as both installation manifests and living documentation.

### Modular Configuration System
18 focused files, each with clear responsibility:
- `startup.sh`: Entry point that sources all modules
- `colors.sh`: 256-color system with custom prompt
- `alias.sh`: 200+ shortcuts following consistent patterns
- `tools.sh`: Custom functions and utilities
- `setup.sh`: Provisioning and package management

## Command Patterns

### Usage Context-Based Naming
- **lowercase compound**: Interactive terminal commands you type manually (`setupzsh`, `photosize`, `photoresize`)
- **camelCase**: Script/programmatic functions that should self-document (`screenSize`, `charCount`, `disableOutput`)
- **Principle**: Don't create aliases for camelCase functions - they exist for script readability, not typing efficiency

### Frequency-Based Naming Hierarchy
- **1-2 chars**: High frequency, muscle memory (`u`, `l`, `gs`, `ga`)
- **3-4 chars**: Medium frequency, tool+action fusion (`nvmu`, `npms`)
- **Consonant compression**: Omit vowels for brevity while avoiding conflicts (`ccnt`, `stst`, `psz`)
- **Descriptive**: Complex but self-documenting (context determines case)

### Safety Through Naming Friction
- **lowercase**: Safe, frequent operations (no shift key = fast typing)
- **compound lowercase**: Dangerous system operations you type manually (requires deliberate typing)
  - `setupzsh`, `uninstallzsh`, `resetzsh` - prevents accidental destruction
- **camelCase**: Script utilities (shift key creates cognitive pause for programmatic use)

### Semantic Naming Patterns
- **lowercase**: Single actions (`path`, `sql`, `ram`)
- **compound lowercase**: Noun+verb structure for related operations (`photosize`, `photoresize`)
- **compound lowercase**: System-level operations (`setupzsh`, `setupBrewPrograms`)

### Tool+Action Fusion
Eliminate flag memorization by merging common operations:
- `nvml` = `nvm list`, `nvmu` = `nvm use`, `nvmup` = upgrade flow
- `npms` = `npm install --save`, `npmd` = `npm install --save-dev`
- `ga` = `git add`, `gc` = `git commit`, `gs` = `git status`

### Workflow Orchestration
Single commands that choreograph multi-step processes with proper timing and backgrounding:
```zsh
cui() {  # ComfyUI workflow
  cd ~/AI/ComfyUI
  python3 ~/AI/ComfyUI/main.py &
  (sleep 3; open -a "Google Chrome" http://127.0.0.1:8188) &
}
```
Pattern: Change directory → Start server → Wait for boot → Open browser → Return control
Eliminates mental overhead of remembering multi-step workflows for flow state preservation.

### Edit Configuration (`e` + component)
- `ea`: Edit aliases
- `epath`: Edit PATH configuration  
- `egit`: Edit git configuration
- `ezsh`: Open entire dotfiles folder (quick reference system)

### Navigation (`h` + location)
- `hd`: Home Desktop
- `hp`: Home Personal Projects
- `hzsh`: Home ZSH dotfiles
- `hweb`: Home web projects

### Directory Movement
- `u`, `u2`, `u3`...`u9`: Move up 1-9 directory levels
- `t`, `t2`, `t3`...`t9`: Tree display with depth control

### Quick Reference
- `ezsh`: Opens dotfiles in default editor for command lookup
- `reload` or `r`: Reload shell configuration
- `i`: Show version info for all package managers

## Error Handling Standard

Visual, educational error pattern used throughout:
```zsh
if [[ -z $1 ]]; then
  print "\n${RED}ERROR:${NC}"
  print "\n  Clear explanation of what's missing"
  print "\n  ${GREEN}command${NC} ${RED}<required-param>${NC}"
  print "\n  Additional context or examples"
fi
```

Colors guide the user: RED for errors, GREEN for correct syntax, BLUE for actions.

## Learning-Optimized Features

### Zero-Friction Development Environment
- `bss()`: Browser-sync with auto-reload for web development
- Screen positioning functions (`screen.sh`) for consistent window layout
- Instant feedback loops minimize context switching during learning

### Maintenance Automation
- `us()`: Universal system update (Homebrew → Node.js → NPM → cleanup)
- `nvmup()`: Node.js version management with automatic package reinstallation
- Progress indicators for long-running operations

### Manual PATH Control
Explicit tool precedence ordering prevents conflicts:
```zsh
# Personal → Homebrew → System (deterministic resolution)
/Users/bravo/.local/bin
/opt/homebrew/bin  
/usr/local/bin
```

### Human-Optimized Information Display
Transform machine-readable into human-scannable:
- `path()`: Vertical list instead of colon-separated string
- Visual error hierarchy with colors
- Self-documenting package arrays with inline comments

### Pattern Extensions for Practice
Suggested pattern for deliberate practice environments:
```zsh
pgit() { # practice git scenarios }
pcss() { # practice CSS challenges }
pjs()  { # practice JavaScript problems }
```

## Development Guidelines

When extending this system:

1. **Follow Existing Patterns**: Use established command patterns (`e`+component, `h`+location)
2. **Add Aliases**: Every function should have a short alias for single-command access
3. **Visual Error Handling**: Include colored, contextual error messages with usage examples
4. **Self-Document**: Add inline comments to package arrays explaining purpose
5. **Test Both States**: Verify both success and failure behaviors
6. **Maintain Modularity**: Add to existing files rather than creating new ones unnecessarily

## Quick Start Commands

- `setupzsh`: Provision new machine (takes ~30 minutes)
- `us`: Update entire development stack
- `ezsh`: Quick reference (opens dotfiles in editor)
- `reload`: Apply configuration changes
- `uninstallzsh`: Clean removal for temporary setups