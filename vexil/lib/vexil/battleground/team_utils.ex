defmodule Vexil.Battleground.TeamUtils do
  alias Vexil.Team
  import Vexil.Battleground.{BotUtils, FlagUtils}

  def random_corner(available_corners) do
    corner =
      available_corners
      |> Enum.random
    available_corners = available_corners -- [corner]
    {available_corners, corner}
  end

  def setup_team({color, name}, %{available_corners: available_corners, game: game}) do
    {available_corners, corner} = random_corner(available_corners)
    team = %Team{color: color, corner: corner, name: name}
    spawn_flag(game, team)
    spawn_bots(game, team)
    %{available_corners: available_corners, game: game}
  end
end
