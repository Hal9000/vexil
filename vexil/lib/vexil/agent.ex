defmodule Vexil.Agent do
  @moduledoc """
  Agent that manages game data.
  """

  @doc """
  Gets a value from the `agent` by `key`.
  """
  def add_pid(agent, pid) do
    pids =
      get(agent, "pids")
      |> List.insert_at(-1, pid)
    update(agent, "pids", pids)
  end

  @doc """
  Gets a value from the `agent` by `key`.
  """
  def get(agent, key) do
    Agent.get(agent, &Map.get(&1, key))
  end

  @doc """
  Puts the `value` for the given `key` in the `agent`.
  """
  def put(agent, key, value) do
    Agent.update(agent, &Map.put_new(&1, key, value))
  end

  @doc """
  Starts a new agent.
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Update the `value` for the given `key` in the `agent`.
  """
  def update(agent, key, value) do
    Agent.update(agent, &Map.put(&1, key, value))
  end
end
