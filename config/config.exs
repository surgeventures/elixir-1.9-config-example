# This file defines build-time configuration. There should be no references to env vars in here
# unless they're REALLY compile-time - which they're usually not as explained here:
#
#   https://12factor.net/config
#
# It is no longer generated by `mix new` but may be added to leverage app env configuration
# only when REALLY needed - either case of an app or truly global configs in lib as explained here:
#
#   https://hexdocs.pm/elixir/master/library-guidelines.html#avoid-application-configuration)

# Replaces `use Mix.Config` for native dep-free config solution
import Config

# Config for mix-oriented dev/test envs and build-time defaults for prod env
config :configurable,
  message: "Test message",
  color: IO.ANSI.cyan(),
  interval: 5_000