defmodule Vexil.Battleground.BotUtils do
  alias Vexil.{Agent, AI, Bot, Team}
  import Vexil.Battleground.GridUtils

  def find_random_coords(game, start_edge, corner, is_x_edge) do
    {coord_x, coord_y} = random_bot_edge_coords(game, start_edge, corner, is_x_edge)
    is_empty =
      Agent.get(game, "grid")
      |> Enum.fetch!(coord_y)
      |> Enum.fetch!(coord_x)
      |> is_nil
    if is_empty do
      {coord_x, coord_y}
    else
      find_random_coords(game, start_edge, corner, is_x_edge)
    end
  end

  def numbers_to_enum(numbers) when is_integer(numbers), do: [numbers]
  def numbers_to_enum(numbers), do: numbers

  def random_bot_corner_coords(game, start_edge, corner) do
    coord_x = Enum.random(start_edge)
    coord_y = Enum.random(start_edge)
    Agent.get(game, "map_last_index")
    |> coords_from_corner(coord_x - 1, coord_y - 1, corner)
  end

  def random_bot_edge_coords(game, start_edge, corner, is_x_edge) do
    max_start_edge =
      start_edge
      |> Enum.to_list
      |> Enum.max
      |> Kernel.-(1)
    {coord_x, coord_y} = if is_x_edge do
      r_coord_x = Enum.random(0..max_start_edge - 1)
      {r_coord_x, max_start_edge}
    else
      r_coord_y = Enum.random(0..max_start_edge - 1)
      {max_start_edge, r_coord_y}
    end
    Agent.get(game, "map_last_index")
    |> coords_from_corner(coord_x, coord_y, corner)
  end

  def spawn_bot(game, coords, config, %Team{color: color}, type) do
    pid = spawn(AI, :loop, [])
    bot_info = config[:stats][type] ++ [ai: pid, team_color: color, type: type]
    bot = struct(Bot, bot_info)
    Agent.add_pid(game, pid)
    send(pid, {:setup, game, bot})
    spawn_item(game, coords, bot)
  end

  def spawn_bot_on_edge(game, config, %Team{corner: corner} = team, type, is_x_edge) do
    start_edge =
      config[:start_edge][type]
      |> numbers_to_enum
    coords = find_random_coords(game, start_edge, corner, is_x_edge)
    spawn_bot(game, coords, config, team, type)
  end

  def spawn_bots(game, %Team{} = team) do
    bots_config = Application.get_env(:vexil, :bot)
    bots_config
    |> Keyword.fetch!(:count)
    |> Enum.each(fn(el) -> spawn_bots(el, bots_config, game, team) end)
  end
  def spawn_bots({type, count}, config, game, %Team{corner: corner} = team) do
    if rem(count, 2) == 1 do
      start_edge =
        config[:start_edge][type]
        |> numbers_to_enum
      coords = random_bot_corner_coords(game, start_edge, corner)
      spawn_bot(game, coords, config, team, type)
      spawn_bots({type, count - 1}, config, game, team)
    else
      half_count = div(count, 2)
      for _ <- 0..half_count - 1, do: spawn_bot_on_edge(game, config, team, type, true)
      for _ <- 0..half_count - 1, do: spawn_bot_on_edge(game, config, team, type, false)
    end
  end
end
