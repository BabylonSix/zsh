screenSize() {

# automatically get screen width
export screenWidth=`osascript <<EOF
tell app "Finder"
	-- get screen dimensions
	set dimensions to bounds of window of desktop
	-- pull out the width
	set wide to item 3 of dimensions
end tell
EOF`

# automatically get screen height
export screenHeight=`osascript <<EOF
tell app "Finder"
	-- get screen dimensions
	set dimensions to bounds of window of desktop
	-- pull out the height
	set wide to item 4 of dimensions
end tell
EOF`

# resulting screen sizes:
# screenHeight
h1_3=$((screenHeight / 3))
h2_3=$((screenHeight / 3 * 2))

h1_4=$((screenHeight / 4))
h2_4=$((screenHeight / 4 * 2))
h3_4=$((screenHeight / 4 * 3))

# screenWidth
w1_3=$((screenWidth / 3))
w2_3=$((screenWidth / 3 * 2))

w1_4=$((screenWidth / 4))
w2_4=$((screenWidth / 4 * 2))
w3_4=$((screenWidth / 4 * 3))

}; screenSize # invoke screenSize fucntion

screenTest() {
	print 'screenHeight'
	print $screenHeight
	print $h1_3
	print $h2_3
	print $h1_4
	print $h2_4
	print $h3_4
	print '\nscreenWidth'
	print $screenWidth
	print $w1_3
	print $w2_3
	print $w1_4
	print $w2_4
}
