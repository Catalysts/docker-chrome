Xvfb :1 -screen 0 1920x1080x24 &
x11vnc -geometry 1920x1080 -display :1 -shared -forever -nopw &
avconv -f x11grab -s 1920x1080 -i :1.0+nomouse -r 20 -vcodec libvpx /tmp/screencast.webm &
