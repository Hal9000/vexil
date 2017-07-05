
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

game = Referee.start(game)

:timer.sleep 20000
# Referee.display(game)

