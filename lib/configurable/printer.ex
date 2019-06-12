defmodule Configurable.Printer do
  @moduledoc false

  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_) do
    print()
    {:ok, nil}
  end

  @impl true
  def handle_info(:print, _) do
    print()
    {:noreply, nil}
  end

  defp print do
    IO.puts(get_formatted_message())
    schedule()
  end

  defp schedule do
    Process.send_after(self(), :print, get_interval())
  end

  defp get_formatted_message do
    get_color() <> get_message() <> IO.ANSI.reset()
  end

  defp get_interval do
    get_env(:interval)
  end

  defp get_message do
    get_env(:message)
  end

  defp get_color do
    get_env(:color)
  end

  defp get_env(key) do
    Application.get_env(:configurable, key)
  end
end
