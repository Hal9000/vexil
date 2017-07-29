defmodule Mix.Tasks.Vexil do
  use Mix.Task

  def run(_) do
    :rand.seed(:exsplus, {0,0,0})
    game = Referee.new
    Referee.display(game)
    game = Referee.start(game)
    :timer.sleep 40000 
    # Referee.display(game)
  end

end
