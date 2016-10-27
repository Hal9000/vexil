require_relative 'grid'
require_relative 'pieces'
require_relative 'referee'
require_relative 'misc'

$game = Referee.new
$game.setup
$game.display

loop do 
  $game.turn
  $game.display
  break if $game.over?
end

puts
