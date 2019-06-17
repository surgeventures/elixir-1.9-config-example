defmodule ReleasesConfigTest do
  use ExUnit.Case

  setup do
    System.put_env("MESSAGE", "x")
    System.delete_env("COLOR")
    System.delete_env("INTERVAL")
    System.delete_env("LOG_LEVEL")

    :ok
  end

  test "valid config" do
    config = Config.Reader.read!("config/releases.exs")

    assert Enum.sort(config[:configurable]) ==
             Enum.sort(message: "x")
  end

  test "missing MESSAGE" do
    System.delete_env("MESSAGE")

    assert_raise(RuntimeError, fn ->
      Config.Reader.read!("config/releases.exs")
    end)
  end

  test "valid COLOR" do
    System.put_env("COLOR", "red")

    config = Config.Reader.read!("config/releases.exs")

    assert config[:configurable][:color] == :red
  end

  test "invalid COLOR" do
    System.put_env("COLOR", "haha")

    assert_raise(RuntimeError, fn ->
      Config.Reader.read!("config/releases.exs")
    end)
  end

  test "valid INTERVAL" do
    System.put_env("INTERVAL", "123")

    config = Config.Reader.read!("config/releases.exs")

    assert config[:configurable][:interval] == 123
  end

  test "invalid INTERVAL" do
    System.put_env("INTERVAL", "haha")

    assert_raise(RuntimeError, fn ->
      Config.Reader.read!("config/releases.exs")
    end)
  end

  test "valid LOG_LEVEL" do
    System.put_env("LOG_LEVEL", "debug")

    config = Config.Reader.read!("config/releases.exs")

    assert config[:logger][:level] == :debug
  end

  test "invalid LOG_LEVEL" do
    System.put_env("LOG_LEVEL", "haha")

    assert_raise(RuntimeError, fn ->
      Config.Reader.read!("config/releases.exs")
    end)
  end
end
