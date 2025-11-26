
FROM alpine:3.20

# Install dependencies
RUN apk add --no-cache xvfb x11vnc xfce4 xauth curl unzip bash openjdk17-jre

# Install Zotero
WORKDIR /opt
RUN curl -L -o zotero.tar.bz2 https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64 \
    && tar -xjf zotero.tar.bz2 \
    && rm zotero.tar.bz2 \
    && mv Zotero_linux-x86_64 zotero

# Install Chrome + Connector
RUN apk add --no-cache chromium chromium-chromedriver

# Create start script
RUN echo '#!/bin/bash\n\
xvfb-run -s "-screen 0 1920x1080x24" /opt/zotero/zotero &' > /start.sh \
    && chmod +x /start.sh

# Expose VNC
EXPOSE 5900

CMD ["x11vnc", "-forever", "-shared"]
