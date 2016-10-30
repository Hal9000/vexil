defmodule Vexil.Battleground.GridUtils do
  alias Vexil.Agent

  def coords_from_corner(_, coord_x, coord_y, :top_left) do
    {coord_x, coord_y}
  end
  def coords_from_corner(map_last_index, coord_x, coord_y, :top_right) do
    {map_last_index - coord_x, coord_y}
  end
  def coords_from_corner(map_last_index, coord_x, coord_y, :bottom_left) do
    {coord_x, map_last_index - coord_y}
  end
  def coords_from_corner(map_last_index, coord_x, coord_y, :bottom_right) do
    {map_last_index - coord_x, map_last_index - coord_y}
  end

  def random_coords(game, range, corner) do
    coord_x = Enum.random(range)
    coord_y = Enum.random(range)
    Agent.get(game, "map_last_index")
    |> coords_from_corner(coord_x, coord_y, corner)
  end

  def spawn_item(game, {coord_x, coord_y}, item) do
    grid =
      Agent.get(game, "grid")
      |> List.update_at(coord_y, fn(row) ->
        List.replace_at(row, coord_x, item)
      end)
    Agent.update(game, "grid", grid)
  end
end
