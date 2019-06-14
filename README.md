# Configurable

**Example project configured with [facilities added in Elixir 1.9](http://blog.plataformatec.com.br/2019/04/whats-new-in-elixir-apr-19/).**

Features:

- [Dockerfile](https://github.com/surgeventures/configurable/blob/master/Dockerfile) that presents how to build minimal image using brand-new official [`mix release`](https://hexdocs.pm/mix/master/Mix.Tasks.Release.html)
- [build-time configuration](https://github.com/surgeventures/configurable/blob/master/config/config.exs) using the new [`Config`](https://hexdocs.pm/elixir/master/Config.html) module instead of deprecated [`Mix.Config`](https://hexdocs.pm/mix/Mix.Config.html)
- [runtime configuration](https://github.com/surgeventures/configurable/blob/master/config/releases.exs) that presents the usage of env vars and how to fail early
- [simple GenServer](https://github.com/surgeventures/configurable/blob/master/lib/configurable/printer.ex) that periodically prints message and leverages the above configuration

Please refer to code comments in above files for more information.

## Usage

Build the release:

```
MIX_ENV=prod mix release
```

Run with valid env vars:

```
MESSAGE="My message" _build/prod/rel/configurable/bin/configurable start
MESSAGE="My message" COLOR=magenta INTERVAL=500 _build/prod/rel/configurable/bin/configurable start
```

Run with missing env var:

```
_build/prod/rel/configurable/bin/configurable start
```

Run with invalid env var:

```
MESSAGE="My message" COLOR=invalid _build/prod/rel/configurable/bin/configurable start
MESSAGE="My message" INTERVAL=foo _build/prod/rel/configurable/bin/configurable start
```

With Docker:

```
docker build . -t app
docker run -e MESSAGE="My message" app bin/configurable start
```
