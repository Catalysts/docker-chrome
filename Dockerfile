FROM ubuntu:14.04

MAINTAINER Lorenz Leutgeb <lorenz.leutgeb@catalysts.cc>

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update -qq && apt-get install -qq \
  wget \
  x11vnc \
  libav-tools \
  xvfb \
  unzip \
  tcpdump

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -qq
 
# install google-chrome-stable dependencies
RUN apt-get install -qq $(apt-cache depends google-chrome-stable | grep Depends | grep -v '|Depends' | sed 's/.*ends:\ //' | tr '\n' ' ')
 
# install google chrome 37
RUN wget -qO- http://mirror.pcbeta.com/google/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_37.0.2062.120-1_amd64.deb > google-chrome.deb
RUN dpkg --install google-chrome.deb && rm google-chrome.deb
RUN google-chrome --version
 
RUN wget -q https://chromedriver.storage.googleapis.com/$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip -qq chromedriver_linux64.zip -d /usr/bin && rm chromedriver_linux64.zip
RUN chromedriver --version

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh .

ENTRYPOINT ["bash", "entrypoint.sh"]

EXPOSE 4444 5900
