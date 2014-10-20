Xvfb :1 -screen 0 1920x1080x24 &
x11vnc -geometry 1920x1080 -display :1 -shared -forever -passwd zinc -o /tmp/x11vnc.log &
avconv -f x11grab -s 1920x1080 -i :1.0+nomouse -r 20 -vcodec libvpx /tmp/screencast.webm &
DISPLAY=:1 chromedriver --logpath=/tmp/chromedriver.log --hostname=127.0.0.1 --port=4444 --url-base=/wd/hub --whitelisted-ips --verbose &
bash
