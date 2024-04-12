FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sepo83"
ENV APPNAME="hibiscus"

ENV JAMEICA_DIR="/config/.jameica"
ENV INSTALL_RUNDUM_SORGLOS='yes'

ENV TITLE=Hibiscus \
    SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# install jameica dependencies
RUN \
    echo "**** add icon ****" && \
    curl -o \
    /kclient/public/icon.png \
    https://github.com/willuhn/hibiscus/blob/master/icons/hibiscus-icon-16x16.png && \
    echo "**** install packages ****" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
    	firefox-esr \
    	gstreamer1.0-alsa \
    	gstreamer1.0-gl \
    	gstreamer1.0-gtk3 \
    	gstreamer1.0-libav \
    	gstreamer1.0-plugins-bad \
    	gstreamer1.0-plugins-base \
    	gstreamer1.0-plugins-good \
    	gstreamer1.0-plugins-ugly \
    	gstreamer1.0-pulseaudio \
    	gstreamer1.0-qt5 \
    	gstreamer1.0-tools \
	gstreamer1.0-x \
    	libgstreamer1.0 \
    	libgstreamer-plugins-bad1.0 \
     	libgstreamer-plugins-base1.0 \
	pcscd \
	openjdk-11-jre \
	libgtk-3-0 \
	aqbanking-tools \
	libaqbanking-data \
	libaqbanking-dev \
	libaqbanking35 \
	libifd-cyberjack6 \
	libchipcard-data \
	pcsc-tools \
	libwebkit2gtk-4.0-37 \
	libwebkit2gtk-4.0-37-gtk2 \
	wget \
	unzip \
	nano

# clean up
RUN  rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

#install jameica
RUN \
    wget -q -O tmp.zip https://www.willuhn.de/products/jameica/releases/current/jameica/jameica-linux64.zip  && \
    unzip tmp.zip -d /opt/ && \
    rm -rf tmp.zip && \
    chmod -R +x /opt/jameica/jameica.sh

# add local files
COPY /root /

# ports and volumes
EXPOSE 3389
VOLUME /config

WORKDIR /config

