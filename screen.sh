screenSize() {

# Declare variables
export screenWidth
export screenHeight

# automatically get screen width
screenWidth=`osascript <<EOF
tell app "Finder"
	-- get screen dimensions
	set dimensions to bounds of window of desktop
	-- pull out the width
	set wide to item 3 of dimensions
end tell
EOF`

# automatically get screen height
screenHeight=`osascript <<EOF
tell app "Finder"
	-- get screen dimensions
	set dimensions to bounds of window of desktop
	-- pull out the height
	set wide to item 4 of dimensions
end tell
EOF`

# resulting screen sizes:
# screenHeight
export h1_3=$((screenHeight / 3))
export h2_3=$((screenHeight / 3 * 2))

export h1_4=$((screenHeight / 4))
export h2_4=$((screenHeight / 4 * 2))
export h3_4=$((screenHeight / 4 * 3))

# screenWidth
export w1_3=$((screenWidth / 3))
export w2_3=$((screenWidth / 3 * 2))

export w1_4=$((screenWidth / 4))
export w2_4=$((screenWidth / 4 * 2))
export w3_4=$((screenWidth / 4 * 3))

}; screenSize # invoke screenSize fucntion

screenTest() {
	print '\n${ORANGE}screenHeight${NC}'
	print '${PINK}${screenHeight}${NC}\t screen height'
	print '${PINK}${h1_3}${NC}\t 1/3 height'
	print '${PINK}${h2_3}${NC}\t 2/3 height'
	print '${PINK}${h1_4}${NC}\t 1/4 height'
	print '${PINK}${h2_4}${NC}\t 2/4 height'
	print '${PINK}${h3_4}${NC}\t 3/4 height'
	print '\n${ORANGE}screenWidth${NC}'
	print '${PINK}${screenWidth}${NC}\t screen width'
	print '${PINK}${w1_3}${NC}\t 1/3 width'
	print '${PINK}${w2_3}${NC}\t 2/3 width'
	print '${PINK}${w1_4}${NC}\t 1/4 width'
	print '${PINK}${w2_4}${NC}\t 2/4 width'
	print '${PINK}${w3_4}${NC}\t 3/4 width'
}
