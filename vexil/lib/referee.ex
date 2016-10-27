defmodule Referee do

  def place(grid, team, kind, x, y) do
# IO.inspect [team, kind, x, y]
    x2 = if Range.range?(x), do: rand(x), else: x
    y2 = if Range.range?(y), do: rand(y), else: y
    
    bot = Bot.make(kind, team, x, y)
    grid = if Grid.cell_empty?(grid, {team, x2, y2}) do
      Grid.put(grid, {team, x2, y2}, bot)
    else
      place(grid, team, kind, x, y)
    end
    # FIXME  pieces[team] << bot
    grid
  end

  def rand(n) when is_integer(n), do: :rand.uniform(n)
  def rand(n1..n2), do: :rand.uniform(n2 - n1 + 1) + n1 - 1

  def setup(grid) do
    grid = setup(grid, :red)     ### line 22
    grid = setup(grid, :blue)
    grid
  end

  def setup(grid, team) do
    grid = place(grid, team, :defender, 5, 5)
    grid = place(grid, team, :defender, 5, 1..4)
    grid = place(grid, team, :defender, 1..4, 5)

    grid = place(grid, team, :fighter, 6, 1..5) 
    grid = place(grid, team, :fighter, 6, 1..5) 
    grid = place(grid, team, :fighter, 6, 1..5) 
    grid = place(grid, team, :fighter, 6, 1..5) 
    grid = place(grid, team, :fighter, 1..5, 6) 
    grid = place(grid, team, :fighter, 1..5, 6) 
    grid = place(grid, team, :fighter, 1..5, 6) 
    grid = place(grid, team, :fighter, 1..5, 6) 

    grid = place(grid, team, :scout, 8..9, 1..9)
    grid = place(grid, team, :scout, 8..9, 1..9)
    grid = place(grid, team, :scout, 8..9, 1..9)
    grid = place(grid, team, :scout, 8..9, 1..9)
    grid = place(grid, team, :scout, 1..9, 8..9)
    grid = place(grid, team, :scout, 1..9, 8..9)
    grid = place(grid, team, :scout, 1..9, 8..9)
    grid = place(grid, team, :scout, 1..9, 8..9)

    grid = place(grid, team, :flag, 1..4, 1..4)

    grid
  end

end
