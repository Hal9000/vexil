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

  def move(game, true, bot, dx, dy), do: {game, bot, false}

  def move(game, false, bot, dx, dy) do
    x2 = bot.x + dx
    y2 = bot.y + dy

    # send msg to referee
    {g, result} = Comms.sendrecv(game.pid, {self(), game, :move, bot.team, bot.x, bot.y, x2, y2})
    bot2 = if result do
      Referee.record(g, :move, bot)  # $game.record("#{self.who} moves to #@x,#@y")
      b2 = %Bot{bot | x: x2}
      b3 = %Bot{b2  | y: y2}
    else
      bot
    end

    {game, bot, result}
  end

  def try_moves(game, bot, dx, dy) do
    deltas = [{dx, dy}, {dx-1, dy+1}, {dx+1, dy-1}, {dx-2, dy+2}, {dx+2, dy-2}]
    {game, bot} = attempt_move(game, bot, deltas)
    {game, bot}
  end

  def attempt_move(game, bot, []), do: {game, bot}

  def attempt_move(game, bot, [dest | rest]) do
    {dx, dy} = dest
    {game, bot, result} = move(game, Referee.over?(game), bot, dx, dy)
    if result do
      {game, bot}
    else
      attempt_move(game, bot, rest)
    end
  end

## credit mononym

  def turn(:fighter, bot, game) do
    # FIXME will call move, attack
    {game, bot} = try_moves(game, bot, 2, 2)
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
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(3, enemy) || break }
    {game, bot}
  end

  def turn(:scout, bot, game) do
    # FIXME will call move, attack
    try_moves(game, bot, 3, 3)
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
