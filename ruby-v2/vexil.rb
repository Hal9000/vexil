require_relative 'grid'
require_relative 'pieces'
require_relative 'referee'
require_relative 'misc'

$game = Referee.new
$game.setup
$game.display

$game.start!

loop do 
  sleep 0.2
  $game.display
  break if $game.over?
end

puts
