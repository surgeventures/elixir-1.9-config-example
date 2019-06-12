# Configurable

**Example project configuration taking advantage of Elixir 1.9+ enhancements.**

Features:

- [build-time configuration](https://github.com/surgeventures/configurable/blob/master/config/config.exs) using the new Config module

- [runtime configuration](https://github.com/surgeventures/configurable/blob/master/config/releases.exs) that presents the way to use required and optional env vars

- [simple GenServer](https://github.com/surgeventures/configurable/blob/master/lib/configurable/printer.ex) that periodically prints message configured in above facilities

## Usage

Build the release:

```
MIX_ENV=prod mix release
```

Run with valid env vars:

```
MESSAGE="My message" COLOR=magenta INTERVAL=500 _build/prod/rel/configurable/bin/configurable start
```

Run with missing env var:

```
COLOR=magenta INTERVAL=500 _build/prod/rel/configurable/bin/configurable start
```

Run with invalid env var:

```
MESSAGE="My message" COLOR=invalid INTERVAL=500 _build/prod/rel/configurable/bin/configurable start
MESSAGE="My message" COLOR=magenta INTERVAL=foo _build/prod/rel/configurable/bin/configurable start
```
