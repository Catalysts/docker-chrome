FROM ubuntu:latest

MAINTAINER Lorenz Leutgeb <lorenz.leutgeb@catalysts.cc>

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get update -qq -y && apt-get install -qq -y \
  wget \
  x11vnc \
  libav-tools \
  xvfb \
  unzip

RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update -qq -y
RUN apt-get install -qq -y google-chrome-stable
RUN google-chrome --version

RUN wget -q https://chromedriver.storage.googleapis.com/$(wget -qO- https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip
RUN unzip -qq chromedriver_linux64.zip -d /usr/bin && rm chromedriver_linux64.zip
RUN chromedriver --version

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh .

ENTRYPOINT ["bash", "entrypoint.sh"]

EXPOSE 4444 5900
