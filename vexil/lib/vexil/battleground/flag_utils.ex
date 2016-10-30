defmodule Vexil.Battleground.FlagUtils do
  alias Vexil.{Flag, Team}
 import Vexil.Battleground.GridUtils

  def spawn_flag(game, %Team{color: color, corner: corner}) do
    flag = %Flag{team_color: color}
    max_flag_edge = Application.get_env(:vexil, :battleground)[:flag_max_edge] - 1
    range = 0..max_flag_edge
    coords = random_coords(game, range, corner)
    spawn_item(game, coords, flag)
  end
end
