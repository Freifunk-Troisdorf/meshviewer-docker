FROM node:13.1.0-alpine

MAINTAINER Stefan Hoffmann <stefan@freifunk-troisdorf.de>, Nils Jakobi <nils@freifunk-troisdorf.de>

# add community repo
RUN echo @community http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

# Install Yarn
RUN apk add \
    build-base \
    gcc \
    git \
#    libffi-dev \
    ruby \
    ruby-dev \
    yarn@community

# Install Grunt
RUN npm install --global grunt-cli && \
    gem install --no-rdoc --no-ri sass -v 3.4.22 && \
    gem install --no-rdoc --no-ri compass

# Clone Meshviewer
WORKDIR /tmp/meshviewer
RUN git clone https://github.com/Freifunk-Troisdorf/meshviewer.git /tmp/meshviewer
RUN ls -alh /tmp/meshviewer

RUN npm install gulp@4 -D
RUN yarn && \
    yarn global add gulp-cli

# create supernode folders
RUN mkdir -p $(printf "/opt/meshviewer/build/data/tdf%d " {4..7})

# gulp this stuff and delete build environment
RUN gulp && \
    cp -r /tmp/meshviewer/build* /opt/meshviewer/build && \
    rm -rf /tmp/meshviewer
