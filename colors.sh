# COLORS
# color values are set from 0 to 255
# print -P "prints to prompt with color ${RED}!${NC}"

# $fg[color]						will set the text color (red, green, blue, etc. - defaults to whatever format set prior to text)
# %F{color} [...] %f		effectively the same as the previous, but with less typing. Can also prefix F with a number instead.
# $fg_no_bold[color]		will set text to non-bold and set the text color
# $fg_bold[color]				will set the text to bold and set the text color
# $reset_color					will reset the text color to the default color. Does not reset bold. use %b to reset bold. Saves typing if it's just %f though.
# %K{color} [...] %k		will set the background color. Same color as non-bold text color. Prefixing with any single-digit number makes the bg black.

# Reset
NC='%f'            # No Color

# Colors
BLACK='%F{240}'    # Black
DARKRED='%F{160}'  # Dark Red
RED='%F{009}'      # Red
GREEN='%F{078}'    # Green
YELLOW='%F{227}'   # Yellow
ORANGE='%F{209}'
BLUE='%F{075}'     # Blue
PURPLE='%F{099}'   # Purple
CYAN='%F{123}'     # Cyan
WHITE='%F{015}'    # White
PINK='%F{213}'     # Pink


# Load Colors for ZSH
autoload -U colors && colors

# ZSH PROMPT LOOK & FEEL
# [user] directory (version control information):
PS1="

[$RED%n$NC] $BLUE%~$NC: $RED\$(vcprompt -f %n:%b$a%u%m)$NC
 $GREEN•➤$NC "

# Set LS to always show colors
export CLICOLOR="Yes"
