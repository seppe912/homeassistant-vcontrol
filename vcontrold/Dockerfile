# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base-debian:trixie
FROM $BUILD_FROM

ENV VCONTROLD_VERSION="v0.98.12"

RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        git \
        libxml2 \
        libxml2-dev \
        mosquitto-clients && \
    git clone --depth 1 --branch "${VCONTROLD_VERSION}" https://github.com/openv/vcontrold.git /tmp/vcontrold && \
    cmake -S /tmp/vcontrold -B /tmp/vcontrold/build -DMANPAGES=OFF && \
    cmake --build /tmp/vcontrold/build --parallel "$(nproc)" && \
    cmake --install /tmp/vcontrold/build && \
    apt-get purge -y --auto-remove \
        build-essential \
        cmake \
        git \
        libxml2-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy root filesystem
COPY rootfs /
