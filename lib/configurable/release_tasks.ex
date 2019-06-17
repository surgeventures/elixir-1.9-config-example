defmodule Configurable.ReleaseTasks do
  @moduledoc """
  One-off tasks available for running against released app via `rpc` or `eval` sub-commands.

  All the tasks make sure that required applications are first started (which in `eval` they're not
  by default and in `rpc` they may not yet be).
  """

  def printer_inspect_metadata do
    Application.ensure_all_started(:configurable)

    IO.inspect(Configurable.Printer.get_metadata())
  end
end
