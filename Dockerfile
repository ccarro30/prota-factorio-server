FROM debian:bullseye-slim

ENV FACTORIO_VERSION="1.1.69"

WORKDIR /usr/src/app

RUN \
    apt update && \
    apt install -y \
        wget \
        xz-utils

RUN wget \
    --progress=bar:force:noscroll \
    -c "https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64" \
    -O "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz"

RUN \
    tar -xJf "factorio_headless_x64_${FACTORIO_VERSION}.tar.xz" -C /opt
    # TODO: More customization

