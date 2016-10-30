defmodule Vexil.Referee do
  alias Vexil.{Battleground, Agent}

  def setup do
    {:ok, pid} = Agent.start_link
    Battleground.setup(pid)
  end

  def start(game) do
    game
    |> Agent.get("pids")
    |> with_pids(fn(pid) -> send(pid, {:start}) end)
    game
  end

  def stop(game) do
    game
    |> Agent.get("pids")
    |> with_pids(fn(pid) -> Process.exit(pid, :kill) end)
  end

  defp with_pids(pids, callback) do
    Enum.each(pids, callback)
  end
end
