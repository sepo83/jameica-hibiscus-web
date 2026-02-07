FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

ENV APPNAME="hibiscus" \
    JAMEICA_DIR="/config/.jameica" \
    TITLE="Hibiscus"

# Alles in einem RUN für Cache-Effizienz
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
      default-jre libgtk-3-0 libwebkit2gtk-4.0-37 libaqbanking44 && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* && \
    \
    curl -o /usr/share/selkies/www/icon.png \
      https://raw.githubusercontent.com/willuhn/hibiscus/master/icons/hibiscus-icon-16x16.png && \
    \
    wget -q -O /tmp/jameica.zip \
      https://www.willuhn.de/products/jameica/releases/current/jameica/jameica-linux64.zip && \
    unzip /tmp/jameica.zip -d /opt/ && rm /tmp/jameica.zip && \
    chmod +x /opt/jameica/jameica.sh && \
    ln -s /opt/jameica/jameica.sh /usr/local/bin/hibiscus && \
    \
    echo '[Desktop Entry]
Name=Hibiscus
Exec=hibiscus
Type=Application
Icon=/usr/share/selkies/www/icon.png
Categories=Finance;' > /usr/share/applications/hibiscus.desktop

COPY root/ /
EXPOSE 3001  # Standard Selkies-Port statt 3389
VOLUME /config
