#unfuck display layout
xrandr --output DP-2.8 --mode 1920x1080 --pos 0x0 --rotate right --output DP-4 --mode 3440x1440 --pos 1080x208

#set background
nitrogen --restore

#start ksuperkey (allowing application-launcher to be started with Win-key)
ksuperkey

#start polybar
exec .config/polybar/launch.sh

#start pulseaudio for audio
pulseaudio -D

#unfuck terminal layout
xrdb ~/.scripts/.Xresources

#start compton for semi-transparent terminal
compton --config ~/.config/compton.conf

