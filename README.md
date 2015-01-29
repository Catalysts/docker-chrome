# docker-chrome

For web testing, we dockerized an X server with recording and VNC, Chrome and ChromeDriver.

## Contents

 * `Xvfb` running at 1920x1080
 * `x11vnc` exposing X at Port 5900 with password `stsylatac` (some clients refuse to connect to a VNC without password set)
 * `avconv` doing a screen capture of X (WebM)
 * `tcpdump` capturing everything for post-mortem analysis of browser tests

Output is written to to `/tmp/artifacts/<command>.(out|err)` so you can easily dump it to any outer system as a volume.

## Tags

 * `beta` will be built with Chrome Beta and the latest ChromeDriver
 * `stable` will be built with Chrome Stable and the latest ChromeDriver
