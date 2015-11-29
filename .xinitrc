#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

xrdb -merge ~/.Xresources

/usr/bin/start-pulseaudio-x11

export GTK2_RC_FILES="$HOME/.gtkrc-2.0" 

# if sleep's needed.
timetosleep = 0.2s

#Display Auflösung, Skalierung und Postion.
display1="VGA1"
display2="DP2"

xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync 
sleep $timetosleep
xrandr --addmode $display1 1920x1200_60.00
sleep $timetosleep

# hdpi method
#xrandr --fb 5640x2880
xrandr --dpi 96
#sleep $timetosleep
#xrandr --output $display1 --scale 2x2 --mode 1920x1200_60.00 --pos 0x0 
#xrandr --output $display2 --rotate right --pos 3840x0 
# non hdpi method, cursor problem, worse if scale-from
# xrandr --output $display1 --mode 1920x1200_60.00 --primary --output $display2 --rotate right --right-of $display1 # --scale-from 1920x1200
xrandr --output $display1 --primary --mode 1920x1200_60.00 --pos 0x0
sleep $timetoosleep
xrandr --output $display2 --mode 2880x1800 --rotate right --pos 1920x0 # --scale-from 1920x1200

## old stuff.
#xrandr --output $display1 --mode 1920x1200 
# workaround for wrong cursor --fbmm 517x323
# start without scaling
# sleep timetosleep
# xrandr --output $display2 --mode "2880x1800" --transform "0.666667,0,0,0,0.666667,0,0,0,1" --right-of $display1
# use this line --fbmm 332x207  --scale-from 1920x1080
#xrandr --output $display2 --mode 2880x1800 --fbmm 331x206 --scale-from 1920x1080 --right-of $display1
#sleep timetosleep
#xrandr --output $display2 --rotate right

# hdpi rot...plus remove touched data from it first. Default.. portrait mode
#rm $HOME/Bin/Daten/.togglehdpi
#rm $HOME/Bin/Daten/.togglerot

# second part of workaround from above
#touch $HOME/Bin/Daten/.togglehdpi

#hdpi rot
#sleep $timetosleep

# composite manager. Fenster durchsichtig usw.
#compton -bcCGf --sw-opti --backend glx --vsync opengl-mswc &
#sleep $timetosleep

# volnoti
# volnoti -t 1 &

exec i3

