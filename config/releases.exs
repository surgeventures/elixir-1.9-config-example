# This file defines runtime configuration. This is where you want to refer to env vars.
#
# Notes:
#
# 1. You'll want to get as aggressive as possible with raising due to env vars being missing or
#    invalid in order for release to fail as early as possible when env is invalid.
#
# 2. Configuration from this file will not get loaded when starting the app via mix - most notably
#    in `iex -S mix` and `mix test`. You should cover these cases in config.exs.
#
# 3. You should completely stop using mix on prod and always use the release binary in order to
#    always have consistent env loaded and avoid some nasty config-related issues.
#
# 4. While this file defines the runtime configuration for prod env, it's still feasible to put the
#    build-time prod configuration in config.exs/prod.exs in order to fail even earlier.
#
# More info:
#
#   https://hexdocs.pm/mix/master/Mix.Tasks.Release.html#module-runtime-configuration

import Config

# Required config - we intentionally ignore the default from config.exs
config :configurable, :message, System.fetch_env!("MESSAGE")

# Optional config - we provide default in place and intentionally override the one from config.exs
config :configurable, :interval, String.to_integer(System.get_env("INTERVAL", "1000"))

# Optional config - we use the default from config.exs and parse/validate as much as possible
with {:ok, color} <- System.fetch_env("COLOR") do
  unless color in ~w[black blue cyan green magenta red white yellow] do
    raise(ArgumentError, "invalid color #{inspect(color)} in environment variable \"COLOR\"")
  end

  color_atom = String.to_atom(color)
  color_code = apply(IO.ANSI, color_atom, [])

  config :configurable, :color, color_code
end
