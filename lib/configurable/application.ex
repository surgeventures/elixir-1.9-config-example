defmodule Configurable.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Configurable.Printer
    ]

    opts = [
      strategy: :one_for_one,
      name: Configurable.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
