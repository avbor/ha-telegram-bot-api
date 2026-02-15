ARG BUILD_NAME="Home Assistant App: Telegram Bot API"
ARG BUILD_DESCRIPTION="Docker image for Telegram Bot API. Built for Home Assistant Apps."
ARG BUILD_VERSION="9.4"
ARG BUILD_ARCH="amd64"

# ---------- Stage 1: Build ----------
FROM alpine:latest AS builder

# Fix branch
# ie: --build-arg TELEGRAM_BOT_API_REF=v9.4
ARG TELEGRAM_BOT_API_REF=master

# Install packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache alpine-sdk linux-headers git zlib-dev openssl-dev gperf cmake

# Clone repo
WORKDIR /src
RUN git clone --recursive https://github.com/tdlib/telegram-bot-api.git . --depth 1 --branch ${TELEGRAM_BOT_API_REF}

# Add proxy support patches
COPY ./add_proxy/*.patch .
RUN patch -p1 ./telegram-bot-api/Client.cpp < Client.cpp.patch && \
    patch -p1 ./telegram-bot-api/ClientParameters.h < ClientParameters.h.patch && \
    patch -p1 ./telegram-bot-api/telegram-bot-api.cpp < telegram-bot-api.cpp.patch

# Build
RUN rm -rf build && mkdir -p build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
    cmake --build . --target telegram-bot-api -j"$(nproc)"

# Strip binary
RUN strip /src/build/telegram-bot-api || true

# ---------- Stage 2: Runtime ----------
ARG BUILD_ARCH

#FROM alpine:latest
FROM ghcr.io/home-assistant/${BUILD_ARCH}-base:latest

# Create user and data folder
RUN addgroup -S telegram-bot-api && \
    adduser -S -D -H -G telegram-bot-api telegram-bot-api

# Copy binary file
COPY --from=builder /src/build/telegram-bot-api /usr/local/bin/telegram-bot-api
COPY run.sh /

RUN chmod a+x /run.sh

CMD [ "/run.sh" ]

ARG BUILD_NAME
ARG BUILD_DESCRIPTION
ARG BUILD_VERSION
ARG BUILD_ARCH
LABEL \
  io.hass.name="${BUILD_NAME}" \
  io.hass.description="${BUILD_DESCRIPTION}" \
  io.hass.arch="${BUILD_ARCH}" \
  io.hass.type="addon" \
  io.hass.version=${BUILD_VERSION} \
  maintainer="avbor (https://github.com/avbor)" \
  org.opencontainers.image.title="${BUILD_NAME}" \
  org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
  org.opencontainers.image.authors="avbor (https://github.com/avbor)" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/avbor/telegram-bot-api" \
  org.opencontainers.image.documentation="https://github.com/avbor/telegram-bot-api/blob/main/README.md" \
  org.opencontainers.image.version=${BUILD_VERSION}