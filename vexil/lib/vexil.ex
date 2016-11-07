defmodule Vexil do
  alias Vexil.Battleground

  defmodule Bot do
    defstruct [:ai, :attack, :defend, :move, :range, :see, :team_color, :type]
  end

  defmodule Flag do
    defstruct [:team_color]
  end

  defmodule Team do
    defstruct [:color, :corner, :name]
  end

  alias Vexil.Referee

  def main(_) do
    game = Referee.setup
    IO.puts "Generated setup:"
    print(game)
    Referee.start(game)
    Referee.stop(game)
    IO.puts "FInal result:"
    print(game)
  end
  
  defp print(game) do
    game
    |> Battleground.grid_to_string
    |> IO.puts
  end
end
