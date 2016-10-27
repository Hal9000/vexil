require 'minitest/autorun'

require_relative 'grid'
require_relative 'pieces'
require_relative 'referee'
require_relative 'misc'

class TestVexil < Minitest::Test

# def setup
#   puts "Ran this"
# end

  def test_001
    $game = Referee.new
    $game.place(Red, Fighter, 7, 7)
    $game.display
    loop { $game.turn; $game.display; sleep 2; break if $game.over? }
  end
end

