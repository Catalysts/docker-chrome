#!/bin/bash

ARTIFACTS=/tmp/artifacts
DISPLAY=:1
SCREEN=0
RESOLUTION=1210x810

mkdir -p $ARTIFACTS

function wrap() {
  $@ > $ARTIFACTS/$1.out 2> $ARTIFACTS/$1.err &
}

function handler() {
  pid=$(pgrep avconv)
  kill -2 $pid
  wait $pid

  pkill -9 -P $$
  wait
}

trap handler TERM INT

wrap Xvfb \
  $DISPLAY \
  -screen $SCREEN \
  ${RESOLUTION}x24

sleep 1

wrap x11vnc \
  -geometry $RESOLUTION \
  -display $DISPLAY \
  -shared \
  -forever \
  -passwd stsylatac

wrap avconv \
  -f x11grab \
  -s $RESOLUTION \
  -i $DISPLAY.$SCREEN+0,0 \
  -r 20 \
  -vcodec libx264 \
  $ARTIFACTS/screencast.mp4

wrap tcpdump \
  -w $ARTIFACTS/tcpdump.pcap

DISPLAY=$DISPLAY wrap chromedriver \
  --hostname=127.0.0.1 \
  --port=4444 \
  --url-base=/wd/hub \
  --whitelisted-ips \
  --verbose

wait
