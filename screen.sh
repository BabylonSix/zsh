screenSize() {

# Define Screen Sizes
macBook17Size() { screenHeight=1200; screenWidth=1920; }
iMacSize() { screenHeight=1; screenWidth=1; }

# invoke desired screen size
macBook17Size

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
