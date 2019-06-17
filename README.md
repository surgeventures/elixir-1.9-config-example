# Configurable

**Example project configured with [facilities added in Elixir 1.9](http://blog.plataformatec.com.br/2019/04/whats-new-in-elixir-apr-19/).**

Features:

- [Dockerfile](https://github.com/surgeventures/configurable/blob/master/Dockerfile) that presents how to build minimal image using brand-new official [`mix release`](https://hexdocs.pm/mix/master/Mix.Tasks.Release.html)
- [build-time configuration](https://github.com/surgeventures/configurable/blob/master/config/config.exs) using the new [`Config`](https://hexdocs.pm/elixir/master/Config.html) module instead of deprecated [`Mix.Config`](https://hexdocs.pm/mix/Mix.Config.html)
- [runtime configuration](https://github.com/surgeventures/configurable/blob/master/config/releases.exs) that presents the usage of env vars and how to fail early
- [simple GenServer](https://github.com/surgeventures/configurable/blob/master/lib/configurable/printer.ex) that periodically prints message and leverages the above configuration
- [unit test for runtime configuration](https://github.com/surgeventures/configurable/blob/master/test/releases_config_test.exs) that verifies it even before the release gets assembled
- [release tasks](https://github.com/surgeventures/configurable/blob/master/lib/configurable/release_tasks.ex) that cover running one-off tasks against the release binary without Mix

Please refer to code comments in above files for more information.

## Usage

Build and run the release:

```
MIX_ENV=prod mix release
MESSAGE=foo _build/prod/rel/configurable/bin/configurable start
```

Build and run the release with Docker:

```
docker build . -t app
docker run -e MESSAGE=foo app bin/configurable start
```

Build and run with Mix (not recommended on actual production):

```
MIX_ENV=prod MESSAGE=foo mix do loadconfig config/releases.exs, run --no-halt
```

Adjust the behavior with valid env vars:

```
MESSAGE=bar COLOR=magenta INTERVAL=500 LOG_LEVEL=debug _build/prod/rel/configurable/bin/configurable start
```

Fail early due to invalid env vars:

```
COLOR=foo INTERVAL=bar LOG_LEVEL=baz _build/prod/rel/configurable/bin/configurable start
```

Run one-off task against already running system:

```
MESSAGE=foo _build/prod/rel/configurable/bin/configurable daemon
_build/prod/rel/configurable/bin/configurable rpc Configurable.ReleaseTasks.printer_inspect_metadata
_build/prod/rel/configurable/bin/configurable stop
```

Run one-off task against clean instance:

```
MESSAGE=foo _build/prod/rel/configurable/bin/configurable eval Configurable.ReleaseTasks.printer_inspect_metadata
```

Run the tests:

```
mix test
```
