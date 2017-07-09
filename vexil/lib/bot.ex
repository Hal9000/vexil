defmodule Comms do 

  def sendrecv(pid, data) do
    send(pid, data)      # send move to referee
    result = receive do  # receive new grid and return val from referee
      {grid, ret} ->
        {grid, ret}
    end
    result
  end

end

defmodule Bot do

  defstruct team: nil, kind: nil, move: nil, see: nil, 
            defend: nil, attack: nil, range: nil, 
            x: nil, y: nil

  def defender(team, x, y) do
    %Bot{team: team, kind: :defender, move: 2, see: 3, defend: 6, attack: 4, range: 2, x: x, y: y}
  end

  def fighter(team, x, y) do
    %Bot{team: team, kind: :fighter, move: 2, see: 3, defend: 6, attack: 4, range: 2, x: x, y: y} # FIXME
  end

  def scout(team, x, y) do
    %Bot{team: team, kind: :scout, move: 2, see: 3, defend: 6, attack: 4, range: 2, x: x, y: y} # FIXME
  end

  def flag(team, x, y) do
    %Bot{team: team, kind: :flag, move: 2, see: 3, defend: 6, attack: 4, range: 2, x: x, y: y} # FIXME
  end

  def make(kind, team, x, y) do
    apply(Bot, kind, [team, x, y])
  end

  def to_string(bot) do
    initial = bot.kind |> Atom.to_string |> String.capitalize |> String.first
    char = if bot.kind == :flag, do: "X", else: initial
    str = 
    if bot.team == :red do
      "\e[31m#{char}\e[0m"
    else
      "\e[34m#{char}\e[0m"
    end
    str
  end

  def move(game, bot, dx, dy) do
    x2 = bot.x + dx
    y2 = bot.y + dy

    bot =
    if not Referee.over?(game) do
      # send msg to referee
      {game, result} = Comms.sendrecv(game.pid, {self(), game, :move, bot.team, bot.x, bot.y, x2, y2})
      if result do
        Referee.record(game, :move, bot)  # $game.record("#{self.who} moves to #@x,#@y")
        # bot2 = Map.update(bot, :x, x2, fn(x) -> x end)
        # Map.update(bot2, :y, y2, fn(x) -> x end)
        bot2 = %Bot{bot | x: x2}
        bot2 = %Bot{bot2 | y: y2}
        bot2
      else
        bot
      end
    end

    {game, bot, result}
  end

  def try_moves(game, bot, dx, dy) do
    deltas = [{dx, dy}, {dx-1, dy+1}, {dx+1, dy-1}, {dx-2, dy+2}, {dx+2, dy-2}]
    attempt_move(game, bot, deltas)
    {game, bot}
  end

  def attempt_move(game, bot, []), do: false

  def attempt_move(game, bot, [dest | rest]) do
    {dx, dy} = dest
    {game, bot, result} = move(game, bot, dx, dy)
    if result do
      {game, bot}
    else
      attempt_move(game, bot, rest)
    end
  end

## credit mononym

## def attempt_move(game, bot, []) do
##     false # <-- whatever failure value here
## end
## 
## def attempt_move(game, bot, [move | rest_of_moves]) do
##     # do something here
##     if successful do
##         true # <-- whatever success value here
##     else
##         attempt_move(game, bot, rest_of_moves)
##     end
## end

  def turn(:fighter, bot, game) do
    # FIXME will call move, attack
    {game, bot} = try_moves(game, bot, 2, 2)
##    return if $game.over?
##    seek_flag
##
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(2, enemy) || break }
##    move!(2, 2)
    {game, bot}
  end

  def turn(:defender, bot, game) do
    # FIXME will call move, attack
##    return if $game.over?
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(3, enemy) || break }
    {game, bot}
  end

  def turn(:scout, bot, game) do
    # FIXME will call move, attack
    try_moves(game, bot, 3, 3)
##    return if $game.over?
##    seek_flag
##
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(1, enemy) || break }
##    move!(3, 3)
    {game, bot}
  end

  def turn(:flag, bot, game), do: {game, bot}

  def mainloop(bot, game) do
    # the bot lives its life -- run, attack, whatever
    # see 'turn' in Ruby version
    {game, bot} = turn(bot.kind, bot, game)
    mainloop(bot, game)
  end

  def awaken(bot, game) do 
    spawn Bot, :mainloop, [bot, game]
  end

end
