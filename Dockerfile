FROM debian:bullseye-slim

# Build and runtime variables
ENV \
    FACTORIO_VERSION="1.1.76" \
    SERVER_PORT="34197" \
    SERVER_USER="factorio" \
    SAVE_NAME="my-save.zip"

WORKDIR /usr/src/app

# Update and install packages
RUN \
    apt-get update && \
    apt-get upgrade && \
    apt-get install -y \
        wget \
        xz-utils

# Download server files
RUN wget \
    --progress=bar:force:noscroll \
    -c "https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64" \
    -O "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz"

# Bootstrap server
RUN \
    tar -xJf "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" -C /opt && \
    rm "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" && \
    mkdir -p /opt/factorio/saves && \
    mkdir -p /opt/factorio/mods && \
    mkdir -p /opt/factorio/config

# Optionally copy in any persistent data
COPY ./saves* /opt/factorio/saves
COPY ./mods* /opt/factorio/mods
COPY ./config* /opt/factorio/config
COPY ./misc* /opt/factorio

# Copy scripts to container
COPY ./bin ./bin

# Bootstrap server process user
RUN \
    useradd -ms /bin/bash $SERVER_USER && \
    chown -R $SERVER_USER:$SERVER_USER /opt/factorio && \
    chown -R $SERVER_USER:$SERVER_USER /usr/src/app

USER $SERVER_USER

EXPOSE $SERVER_PORT/udp
