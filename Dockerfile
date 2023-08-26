# Intermediate stage for acquiring server files
FROM debian:bullseye-slim AS init

# Build arguments
ARG FACTORIO_VERSION="1.1.87"

# Install build-time packages
RUN \
    apt-get update && \
    apt-get install -y \
        wget \
        xz-utils

# Download and unpack server files
RUN \
    wget \
      --progress=bar:force:noscroll \
      -c "https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64" \
      -O "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" && \
    tar -xJf "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" -C /opt && \
    rm "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz"

# Stage for final server image; Improves image size and allows for build parallelism
FROM debian:bullseye-slim AS server

# Runtime variables
ENV \
    SERVER_PORT="34197" \
    SERVER_USER="factorio" \
    SAVE_NAME="my-save.zip"

WORKDIR /usr/src/app

# Update base image packages
RUN \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        wget \
        jq

# Copy scripts to container
COPY ./bin ./bin

# Copy factorio base files from intermediate stage
COPY --from=init /opt/factorio /opt/factorio

# Add in supporting directories
RUN \
    mkdir -p /opt/factorio/saves && \
    mkdir -p /opt/factorio/mods && \
    mkdir -p /opt/factorio/config && \
    mkdir -p /opt/factorio/log

# Optionally copy in any persistent data
COPY ./saves* /opt/factorio/saves
COPY ./mods* /opt/factorio/mods
COPY ./config* /opt/factorio/config
COPY ./log* /opt/factorio/log

# Bootstrap server process user
RUN \
    useradd -ms /bin/bash $SERVER_USER && \
    chown -R $SERVER_USER:$SERVER_USER /opt/factorio && \
    chown -R $SERVER_USER:$SERVER_USER /usr/src/app

# Set server process user as active user
USER $SERVER_USER

# Expose container on port specified
EXPOSE $SERVER_PORT/udp
