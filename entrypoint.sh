Xvfb :1 -screen 0 1920x1080x24 > /tmp/Xvfb.out 2> /tmp/Xvfb.err &
x11vnc -geometry 1920x1080 -display :1 -shared -forever -passwd zinc > /tmp/x11vnc.out 2> /tmp/x11vnc.err  &
avconv -f x11grab -s 1920x1080 -i :1.0+nomouse -r 20 -vcodec libvpx /tmp/screencast.webm > /tmp/avconv.out 2> /tmp/avconv.err &
DISPLAY=:1 chromedriver --hostname=127.0.0.1 --port=4444 --url-base=/wd/hub --whitelisted-ips --verbose > /tmp/chromedriver.out 2> /tmp/chromedriver.err 
