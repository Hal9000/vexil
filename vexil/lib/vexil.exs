
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


:rand.seed(:exsplus, {0,0,0})

game = Referee.new

Referee.display(game)

IO.puts "got here"

game = Referee.start(game)

# IO.puts "cp3 - grid = #{inspect game}"

:timer.sleep 2000
Referee.display(game)

# {game, ret} = Comms.sendrecv(pid, {self(), :move, :red, 5, 3, 4, 3})

# IO.inspect foo

:timer.sleep 2000
Referee.display(game)
# 
# :timer.sleep 1000
# Referee.display(game)
# 
# :timer.sleep 1000
# Referee.display(game)
# 
# :timer.sleep 1000
# Referee.display(game)
# 
# :timer.sleep 1000
# Referee.display(game)
# 
