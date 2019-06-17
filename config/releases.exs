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
#    always have consistent env loaded (unless you want to rely on `mix loadconfig`).
#
# 4. While this file defines the runtime configuration for prod env, it's still feasible to put the
#    build-time prod configuration in config.exs/prod.exs in order to fail even earlier.
#
# More info:
#
#   https://hexdocs.pm/mix/master/Mix.Tasks.Release.html#module-runtime-configuration

# Same configuration DSL as for build-time configuration
import Config

# List of all used env vars along with information if they're required
env_vars = [
  {"COLOR", :optional},
  {"INTERVAL", :optional},
  {"LOG_LEVEL", :optional},
  {"MESSAGE", :required}
]

# Function for parsing and validation of env vars that did get set in the env
process_present_envs = fn
  {"MESSAGE", message} ->
    config :configurable, :message, message

  {"INTERVAL", interval} ->
    with {interval_integer, ""} <- Integer.parse(interval) do
      config :configurable, :interval, interval_integer
    else
      _ -> "INTERVAL not integer: #{inspect(interval)}"
    end

  {"COLOR", color} when color in ~w[black blue cyan green magenta red white yellow] ->
    config :configurable, :color, String.to_atom(color)

  {"COLOR", color} ->
    "COLOR invalid: #{inspect(color)}"

  {"LOG_LEVEL", level} when level in ~w[debug info warn error] ->
    config :logger, :level, String.to_atom(level)

  {"LOG_LEVEL", level} ->
    "LOG_LEVEL invalid: #{inspect(level)}"
end

# Wrapper for also handling of env vars that didn't get set in the env
process_present_and_absent_envs = fn
  {env, _requirement, {:ok, value}} -> process_present_envs.({env, value})
  {env, :required, :error} -> "#{env} missing"
  {_env, :optional, :error} -> :ok
end

# Collect error strings and raise them all at once
errors =
  env_vars
  |> Enum.map(fn {name, requirement} -> {name, requirement, System.fetch_env(name)} end)
  |> Enum.map(process_present_and_absent_envs)
  |> Enum.filter(&is_binary/1)

if Enum.any?(errors) do
  raise("Environment variable errors: #{Enum.join(errors, ", ")}")
end
