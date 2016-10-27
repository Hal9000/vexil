# defmodule Vexil do
# end

# def place(grid, team, kind, x, y) do

IO.puts "got here"

grid = %{}
grid = Referee.place(grid, :red, :defender, 5, 5)

Grid.display(grid)


IO.puts "alao here"
