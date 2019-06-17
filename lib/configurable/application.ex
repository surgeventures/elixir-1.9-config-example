defmodule Configurable.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children =
      if Application.get_env(:configurable, :start_printer) do
        [
          Configurable.Printer
        ]
      else
        []
      end

    opts = [
      strategy: :one_for_one,
      name: Configurable.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
