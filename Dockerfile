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

FROM elixir as builder
RUN mix local.rebar --force && mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod
COPY mix.* .
RUN mix deps.get --only prod
RUN mix deps.compile
COPY . .
RUN mix release

FROM alpine:3.9
RUN apk update && apk add --no-cache bash openssl-dev
COPY --from=builder /app/_build/prod/rel/configurable /app
WORKDIR /app
