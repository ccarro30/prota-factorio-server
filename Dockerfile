FROM debian:bullseye-slim

# Build and Runtime Variables
ENV \
  FACTORIO_VERSION="1.1.74" \
  SERVER_PORT="34197" \
  SERVER_USER="factorio" \
  SAVE_NAME="my-save.zip"

WORKDIR /usr/src/app

# Copy Scripts to Container
COPY ./bin ./bin

# Update and Install Packages
RUN \
    apt-get update && \
    apt-get install -y \
        wget \
        xz-utils

# Download Server Files
RUN wget \
    --progress=bar:force:noscroll \
    -c "https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64" \
    -O "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz"

# Bootstrap Server
RUN \
    tar -xJf "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" -C /opt && \
    rm "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" && \
    mkdir -p /opt/factorio/saves && \
    mkdir -p /opt/factorio/mods && \
    mkdir -p /opt/factorio/config

COPY ./saves* /opt/factorio/saves
COPY ./mods* /opt/factorio/mods
COPY ./config* /opt/factorio/config

# Bootstrap User
RUN \
    adduser $SERVER_USER && \
    chown -R $SERVER_USER:$SERVER_USER /opt/factorio && \
    chown -R $SERVER_USER:$SERVER_USER /usr/src/app

USER $SERVER_USER

EXPOSE $SERVER_PORT/udp
