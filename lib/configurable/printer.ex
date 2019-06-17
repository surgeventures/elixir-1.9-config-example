defmodule Configurable.Printer do
  @moduledoc """
  Periodically prints to stdout.

  - prints configured message with configured color in configured intervals allowing to verify that
    build-time and runtime configuration works as expected

  - logs debug information allowing to verify that built-in :logger OTP application respects its
    configuration just as the :configurable application does

  - offers API for fetching metadata that changes over time allowing to present the organization of
    one-off task code within project based on releases
  """

  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_metadata do
    GenServer.call(__MODULE__, :get_metadata)
  end

  @impl true
  def init(_) do
    Process.send_after(self(), :print, 0)

    {:ok, [started_at: DateTime.utc_now(), count: 0]}
  end

  @impl true
  def handle_info(:print, metadata) do
    Process.send_after(self(), :print, get_interval())

    formatted_message = apply(IO.ANSI, get_color(), []) <> get_message() <> IO.ANSI.reset()
    IO.puts(formatted_message)

    Logger.debug("Printed message", metadata)

    {:noreply, Keyword.update!(metadata, :count, &(&1 + 1))}
  end

  @impl true
  def handle_call(:get_metadata, _, metadata) do
    {:reply, metadata, metadata}
  end

  defp get_interval do
    Application.get_env(:configurable, :interval)
  end

  defp get_message do
    Application.get_env(:configurable, :message)
  end

  defp get_color do
    Application.get_env(:configurable, :color)
  end
end
