FROM ubuntu:latest

MAINTAINER Lorenz Leutgeb <lorenz.leutgeb@catalysts.cc>

#EXPOSE 4444

RUN sudo apt-get update

# install dependencies
RUN sudo apt-get install -y \
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

# setup google's chrome repo and install chrome stable
RUN sudo wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
RUN sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN sudo apt-get update
RUN sudo apt-get install -y google-chrome-stable
RUN google-chrome --version

# setup latest chromedriver
RUN sudo wget -q https://chromedriver.storage.googleapis.com/LATEST_RELEASE
RUN sudo wget -q https://chromedriver.storage.googleapis.com/$(cat LATEST_RELEASE)/chromedriver_linux64.zip
RUN sudo unzip chromedriver_linux64.zip
RUN sudo rm LATEST_RELEASE chromedriver_linux64.zip
RUN sudo mv chromedriver /usr/bin
RUN chromedriver --version

# setup latest selenium standalone server
RUN sudo pip install gsutil
RUN gsutil cp $(gsutil ls "gs://selenium-release/**selenium-server-standalone-*.jar" | tail -n 1) selenium-server-standalone.jar

# start selenium
#RUN java -jar selenium-server-standalone.jar \
#  -port 4444 \
#  -forcedBrowserMode '*chrome'
#  -trustAllSSLCertificates
#  -log ...

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
