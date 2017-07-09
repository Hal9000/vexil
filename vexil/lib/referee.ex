
# Also credit di4na mjadczak

defmodule Grid do

  def get(grid, {:red, x, y}),  do: Map.get(grid, {:red, x, y})
  def get(grid, {:blue, x, y}), do: Map.get(grid, {:red, 22-x, 22-y})

  def put(grid, {:red, x, y}, piece),  do: Map.put(grid, {:red, x, y}, piece)
  def put(grid, {:blue, x, y}, piece), do: Map.put(grid, {:red, 22-x, 22-y}, piece)

  def show_cell(grid, xx, yy) do
    bot = Grid.get(grid, {:red, xx, yy})
    char = if bot == nil, do: "-", else: Bot.to_string(bot)
    IO.write "#{char} "
  end

  def cell_empty?(grid, triple) do
    bot = Grid.get(grid, triple)
    bot == nil
  end

  def display(grid) do
    IO.puts "\e[H\e[2J"  # clear screen
    yrange = 21..1
    xrange = 1..21
    Enum.each yrange, fn(y) -> 
      Enum.each xrange, fn(x) -> show_cell(grid, x, y) end
      IO.puts ""
    end
  end

end

### 

defmodule Referee do

  defstruct [:grid, :bots, :pid]

  def new do 
    {grid, bots} = setup(%{})
    %Referee{grid: grid, bots: bots, pid: nil}
  end

  def place(grid, bots, team, kind, x, y) do
    x2 = if Range.range?(x), do: rand(x), else: x
    y2 = if Range.range?(y), do: rand(y), else: y
    
    bot = Bot.make(kind, team, x2, y2)
    {grid, bots} = 
    if Grid.cell_empty?(grid, {team, x2, y2}) do
      {Grid.put(grid, {team, x2, y2}, bot), bots}
    else
      place(grid, bots, team, kind, x, y)
    end
    bots = [bot] ++ bots
    {grid, bots}
  end

  def rand(n) when is_integer(n), do: :rand.uniform(n)
  def rand(n1..n2), do: :rand.uniform(n2 - n1 + 1) + n1 - 1

  def setup(grid) do
    {grid, redbots} = setup(grid, :red)
    {grid, bluebots} = setup(grid, :blue)
    bots = redbots ++ bluebots
    {grid, bots}
  end

  def setup(grid, team) do
    bots = []
    {grid, bots} = place(grid, bots, team, :defender, 5, 5)
    {grid, bots} = place(grid, bots, team, :defender, 5, 1..4)
    {grid, bots} = place(grid, bots, team, :defender, 1..4, 5)

    {grid, bots} = place(grid, bots, team, :fighter, 6, 1..5) 
    {grid, bots} = place(grid, bots, team, :fighter, 6, 1..5) 
    {grid, bots} = place(grid, bots, team, :fighter, 6, 1..5) 
    {grid, bots} = place(grid, bots, team, :fighter, 6, 1..5) 
    {grid, bots} = place(grid, bots, team, :fighter, 1..5, 6) 
    {grid, bots} = place(grid, bots, team, :fighter, 1..5, 6) 
    {grid, bots} = place(grid, bots, team, :fighter, 1..5, 6) 
    {grid, bots} = place(grid, bots, team, :fighter, 1..5, 6) 

    {grid, bots} = place(grid, bots, team, :scout, 8..9, 1..9)
    {grid, bots} = place(grid, bots, team, :scout, 8..9, 1..9)
    {grid, bots} = place(grid, bots, team, :scout, 8..9, 1..9)
    {grid, bots} = place(grid, bots, team, :scout, 8..9, 1..9)
    {grid, bots} = place(grid, bots, team, :scout, 1..9, 8..9)
    {grid, bots} = place(grid, bots, team, :scout, 1..9, 8..9)
    {grid, bots} = place(grid, bots, team, :scout, 1..9, 8..9)
    {grid, bots} = place(grid, bots, team, :scout, 1..9, 8..9)

    {grid, bots} = place(grid, bots, team, :flag, 1..4, 1..4)

    {grid, bots}
  end

  def display(game) do
    Grid.display(game.grid)
  end

  def move(game, team, x0, y0, x1, y1) do
    grid = game.grid
    piece = Grid.get(grid, {team, x0, y0})
    dest = Grid.get(grid, {team, x1, y1})
    {grid, ret} = 
      cond do 
        dest == nil ->
#         IO.puts "move cp1"
          g = Grid.put(grid, {team, x1, y1}, piece)
          g = Grid.put(g, {team, x0, y0}, nil)
          true = Grid.get(g, {team, x0, y0}) == nil
          true = Grid.get(g, {team, x1, y1}) != nil
          {g, true}
        dest in [:redflag, :blueflag] ->
#         IO.puts "move cp2"
          g = Grid.put(grid, {team, x1, y1}, piece)
          g = Grid.put(g, {team, x0, y0}, nil)
          # FIXME mark game as over
          {g, false}  # logic??
        true ->
#         IO.puts "move cp3"
          {grid, false}
      end
    game = %Referee{game | grid: grid}
    {game, ret}
  end

  def over?(_x), do: false       # FIXME

  def record(_x, _y, _z), do: nil  # FIXME

  def start(game) do
    pid = spawn Referee, :mainloop, [game]
    game = %Referee{game | pid: pid}
    Enum.each(game.bots, fn(bot) -> Bot.awaken(bot, game) end)
    game
  end

  def mainloop(game) do
    game = receive do
      {caller, game, :move, team, x0, y0, x1, y1} ->
        IO.puts "mainloop: #{team} moves from #{inspect {x0, y0}} to #{inspect {x1, y1}}"
        {g, ret} = move(game, team, x0, y0, x1, y1)
        send(caller, {g, ret})
        Grid.display(g.grid)
        g
    end
    :timer.sleep 500
    mainloop(game) # tail call optimized
  end

end
