# COLORS
# %F{n}...%f  foreground (0-255)
# %K{n}...%k  background
# %b          reset bold
# %f%b%k      full reset
# print "text with color ${RED}!${NC}"
print() { builtin print -P "$@" }

# Reset (foreground + bold + background)
NC='%f%b%k'       # No Color / full reset

# Colors
BLACK='%F{240}'    # Black
DARKRED='%F{160}'  # Dark Red
RED='%F{009}'      # Red
GREEN='%F{078}'    # Green
YELLOW='%F{227}'   # Yellow
ORANGE='%F{209}'   # Orange
BLUE='%F{075}'     # Blue
PURPLE='%F{099}'   # Purple
CYAN='%F{123}'     # Cyan
WHITE='%F{015}'    # White
PINK='%F{211}'     # Pink

# Load Colors for ZSH
autoload -U colors && colors

# ZSH PROMPT LOOK & FEEL
eval "$(starship init zsh)"

# Set LS to always show colors
export CLICOLOR="Yes"
