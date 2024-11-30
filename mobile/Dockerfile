FROM ghcr.io/cirruslabs/flutter:3.19.5 as build-env

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
ENV PATH="${PATH}:/usr/bin"

RUN flutter build web


