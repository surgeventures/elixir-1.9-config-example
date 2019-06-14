# Custom RC build of Elixir needed due to lack of official elixir:1.9 image.
# Based on official elixir:x.y.z-alpine dockerfiles.
# May be removed once Elixir 1.9 gets out of RC phase and have image released on DockerHub.
FROM erlang:21-alpine as elixir
ENV ELIXIR_VERSION="v1.9.0-rc.0" LANG=C.UTF-8
RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && buildDeps='ca-certificates curl make' \
  && apk add --no-cache --virtual .build-deps $buildDeps \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean \
  && apk del .build-deps

# Intermediate "fat" build with source code, Erlang, Elixir, deps, dev libs etc.
FROM elixir as builder
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app/source
ENV MIX_ENV=prod
COPY mix.* .
RUN mix deps.get --only prod
RUN mix deps.compile
COPY . .
RUN mix release --path /app/release

# Final "slim" build based on the same version of Alpine Linux as in builder.
FROM alpine:3.9
RUN apk update && apk add --no-cache bash openssl-dev
COPY --from=builder /app/release /app
WORKDIR /app
