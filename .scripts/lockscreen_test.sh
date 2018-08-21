
#!/bin/bash
# /usr/bin/blurlock

# The folder where you store the mask
FOLDER='/home/alex/Bilder/.lockscreen'

# Default color of ring
D='#888888aa'
# Default color of inside
I='#88888800'
# Verifying ring color
V='#bbbbbbff'
# Wrong ring color
W='#aa888800'
# Color of separator
L='#dddddd00'
# Color of outer separator
S='#DDDDDD00'

# Radius of unlock indicator
WIDTH=100
# Radius of the ring around the indicator
RWIDTH=4

# Get random photo from picsum.photos. The resolution is the combined width of your monitors and the height is that of the tallest monitor you have
wget -q -O /tmp/unsplash-lockscreen.jpg https://picsum.photos/4520/1920/?random

# Give the image a blurred
convert /tmp/unsplash-lockscreen.jpg -mask $FOLDER/blur-mask-lockscreen.png -blur 0x8 +mask /tmp/unsplash-lockscreen.png

# Get the average RGB color of the blurred circle
rgb=$(convert /tmp/unsplash-lockscreen.png -crop 50x50+3175+335 -resize 1x1\! -format "%[fx:int(255*r+.5)] %[fx:int(255*g+.5)] %[fx:int(255*b+.5)]" info:-)

# Convert those values into an array
rgb=( $rgb )

# Multiply those RGB values by their perceived brightness. I tweaked these a little, so if you find the colors aren't quite right for you, go ahead and change those decimals.
# https://stackoverflow.com/questions/1855884/determine-font-color-based-on-background-color#1855903
currentColor=$(echo "scale=4; 0.344*${rgb[0]}" | bc)
currentColor=$(echo "scale=4; (0.547*${rgb[1]})+$currentColor" | bc)
currentColor=$(echo "scale=4; (0.101*${rgb[2]})+$currentColor" | bc)

# Convert those into a value between 0 and 1
currentColor=$(echo "scale=4; 1-($currentColor/255)" | bc)

# If the image is bright, make the text dark, and vice versa
if [[ `echo "$currentColor 0.5" | awk '{print ($1 < $2)}'` == 1 ]]; then
	T='#000000ff'
	D='#444444ff'
else
	T='#eeeeeeff'
fi
# echo $currentColor

# lock the screen
i3lock --linecolor=$L --separatorcolor=$S -k --timecolor=$T --datecolor=$T --indicator --ringcolor=$D --insidecolor=$I --keyhlcolor=$V  --timestr="%H:%M" -S HDMI1 --veriftext="" --ringvercolor=$V --insidevercolor=$D --wrongtext="" --ringwrongcolor=$W --datestr="%a, %b %d" --insidewrongcolor=$V -i /tmp/unsplash-lockscreen.png --radius=$WIDTH i --ring-width=$RWIDTH

exit 0


