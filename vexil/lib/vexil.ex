defmodule Vexil do
# use Application

  def main do   # start(_type, _args) do
    for _ <- 1..20 do
    grid = %{}
    grid = Referee.setup(grid)
    Grid.display(grid)
    :timer.sleep 200
    end
  end

end

