defmodule Vexil.Battleground do
  alias Vexil.{Agent, Bot, Flag}
  import Vexil.Battleground.TeamUtils

  def setup(game) do
    team_teritory_side_length =
      Application.get_env(:vexil, :bot)[:start_edge]
      |> Keyword.values
      |> Enum.map(&parse_start_edges/1)
      |> List.flatten
      |> Enum.max
    neutral_extra_space = Application.get_env(:vexil, :battleground)[:neutral_extra_space]
    map_side_length = team_teritory_side_length * 2 + neutral_extra_space
    Agent.put(game, "map_last_index", map_side_length - 1)
    grid =
      nil
      |> List.duplicate(map_side_length)
      |> List.duplicate(map_side_length)
    Agent.put(game, "grid", grid)
    Agent.put(game, "pids", [])
    data = %{
       available_corners: [:top_left, :top_right, :bottom_left, :bottom_right],
       game: game
    }
    Application.get_env(:vexil, :teams)
    |> Enum.reduce(data, &setup_team/2)
    game
  end

  defp parse_start_edges(count) when is_integer(count), do: count
  defp parse_start_edges(range) do
    range
    |> Enum.to_list
  end

  def grid_to_string(game) do
    Agent.get(game, "grid")
    |> Enum.map(fn(row) -> row_to_string(row) end)
    |> Enum.join("\n")
  end

  defp row_to_string(row) do
    row
    |> Enum.map(fn(cell) -> cell_to_string(cell) end)
    |> Enum.join
  end

  defp cell_to_string(nil), do: "-"
  defp cell_to_string(%Flag{team_color: color}) do
    [color, "X"]
    |> Bunt.format
  end
  defp cell_to_string(%Bot{team_color: color, type: type}) do
    result =
      type
      |> Atom.to_string
      |> String.first
      |> String.upcase
    [color, result]
    |> Bunt.format
  end
end
