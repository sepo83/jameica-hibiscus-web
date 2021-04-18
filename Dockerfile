FROM ghcr.io/linuxserver/baseimage-guacgui

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sepo83"
ENV APPNAME="hibiscus"

ENV JAMEICA_DIR="/config/.jameica"
ENV INSTALL_RUNDUM_SORGLOS='yes'

#ENV CUSTOM_PORT="8080"

# install jameica dependencies
RUN apt update && apt dist-upgrade -y && \
    apt install -qy \
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

