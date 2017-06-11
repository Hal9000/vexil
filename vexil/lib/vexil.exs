
### $game = Referee.new
### $game.setup
### $game.display
### 
### $game.start!
### 
### loop do 
###   sleep 0.2
###   $game.display
###   break if $game.over?
### end

defmodule Comms do 

  def sendrecv(pid, data) do
    send(pid, data)      # send move to referee
    result = receive do  # receive new grid and return val from referee
      {grid, ret} ->
        {grid, ret}
    end
IO.puts "got a result"
IO.inspect result
    result
  end

end


:rand.seed(:exsplus, {0,0,0})

game = %{}
{game, bots} = Referee.setup(game)
Grid.display(game)

pid = Referee.start(game, bots)

# IO.puts "cp3 - grid = #{inspect game}"

:timer.sleep 2000

{game, ret} = Comms.sendrecv(pid, {self(), :move, :red, 5, 3, 4, 3})

# IO.inspect foo

:timer.sleep 2000
Grid.display(game)


