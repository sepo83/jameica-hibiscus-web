FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV APPNAME="hibiscus" \
    JAMEICA_DIR="/config/.jameica" \
    TITLE="Hibiscus"

# Alles in einem RUN für Cache-Effizienz
RUN \
    echo "**** create man dir (workaround for installation error in openjdk) ****" && \
    mkdir -p /usr/share/man/man1 && \
    echo "**** install packages ****" && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive \
    apt install --no-install-recommends -y \
      wget \
      unzip \
      openjdk-21-jre-headless \
      libgtk-3-0 \
      libaqbanking44 && \
    \
    echo "**** Fix Java manpages (workaround for installation error in openjdk) ****" && \
    mkdir -p /usr/share/man/man1.dpkg-tmp && \
    ln -s /usr/lib/jvm/java-21-openjdk-amd64/man/man1/java.1.gz /usr/share/man/man1/java.1.gz || true && \
    echo "**** cleanup ****" && \
    apt-get autoclean && \
    rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/* && \
    \
    echo "**** add icon ****" && \
    curl -o /usr/share/selkies/www/icon.png \
      https://raw.githubusercontent.com/willuhn/hibiscus/master/icons/hibiscus-icon-16x16.png && \
    \
    echo "**** install jameica ****" && \
    wget -q -O /tmp/jameica.zip \
      https://www.willuhn.de/products/jameica/releases/current/jameica/jameica-linux64.zip && \
    unzip /tmp/jameica.zip -d /opt/ && rm /tmp/jameica.zip && \
    chmod +x /opt/jameica/jameica.sh && \
    ln -s /opt/jameica/jameica.sh /usr/local/bin/hibiscus

COPY root/ /
EXPOSE 3001 
VOLUME /config
