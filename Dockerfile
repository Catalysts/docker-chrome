FROM ubuntu:latest

MAINTAINER Lorenz Leutgeb <lorenz.leutgeb@catalysts.cc>

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

#EXPOSE 4444

RUN sudo apt-get update -qq -y

RUN sudo apt-get install -qq -y \
  wget \
  x11vnc \
#  gnuplot \
#  md5deep \
#  procps \
#  build-essential \
  libav-tools \
  xvfb \
  unzip \
  openjdk-7-jre-headless \
  libwww-perl \
  gcc python-dev python-setuptools libffi-dev python-pip libssl-dev

RUN sudo wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN sudo apt-get -qq -y update
RUN sudo apt-get install -qq -y google-chrome-stable
RUN google-chrome --version

RUN sudo pip install -q gsutil

RUN sudo gsutil cp gs://chromedriver/$(sudo gsutil cp gs://chromedriver/LATEST_RELEASE -)/chromedriver_linux64.zip .
RUN sudo unzip -qq chromedriver_linux64.zip -d /usr/bin && rm chromedriver_linux64.zip
RUN chromedriver --version

RUN gsutil cp $(gsutil ls 'gs://selenium-release/**selenium-server-standalone-*.jar' | tail -n 1) selenium-server-standalone.jar

# start selenium
#RUN java -jar selenium-server-standalone.jar \
#  -port 4444 \
#  -forcedBrowserMode '*chrome'
#  -trustAllSSLCertificates
#  -log ...

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
