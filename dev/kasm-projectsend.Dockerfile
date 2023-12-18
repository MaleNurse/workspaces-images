# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.18

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PROJECTSEND_VERSION
LABEL build_version="Docker.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="doctorwhen"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php82-bcmath \
    php82-bz2 \
    php82-cli \
    php82-dom \
    php82-gd \
    php82-gettext \
    php82-gmp \
    php82-mysqli \
    php82-pdo \
    php82-pdo_dblib \
    php82-pdo_mysql \
    php82-pecl-apcu \
    php82-pecl-memcached \
    php82-soap \
    php82-xmlreader && \
  apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php82-pecl-mcrypt && \
  echo "**** install projectsend ****" && \
  mkdir -p /app/www/public && \
  if [ -z ${PROJECTSEND_VERSION+x} ]; then \
    PROJECTSEND_VERSION=$(curl -s https://api.github.com/repos/projectsend/projectsend/releases/latest | jq -r '. | .tag_name'); \
  fi && \
  curl -fso \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend-${PROJECTSEND_VERSION}.zip" || \
  curl -fso \
    /tmp/projectsend.zip -L \
    "https://github.com/projectsend/projectsend/releases/download/${PROJECTSEND_VERSION}/projectsend.zip" && \
  unzip \
    /tmp/projectsend.zip -d \
    /app/www/public && \
  mv /app/www/public/upload /defaults/ && \
  mv /app/www/public /app/www/public-tmp && \
  echo "**** cleanup ****" && \
    rm -rf \
    /tmp/*

# copy local files
COPY ./src/alpine/install/projectsend/root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
