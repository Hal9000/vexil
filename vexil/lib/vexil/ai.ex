defmodule Vexil.AI do
  def loop(keyword \\ nil) do
    receive do
      {:setup, game, bot} ->
        loop(bot: bot, game: game)
      {:start} ->
        turn(keyword)
    end
  end

  defp turn(keyword) do
    IO.puts "AI (#{inspect self}): I can not think now, I'm so sorry. ;-)"
    :timer.sleep(1000)
    turn(keyword)
  end
end
