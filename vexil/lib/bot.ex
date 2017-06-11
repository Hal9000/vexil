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

    # FIXME will send msg to referee

    {game, bot}
  end

  def turn(:fighter, bot, refpid, game) do
    # FIXME will call move, attack
##    return if $game.over?
##    seek_flag
##
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(2, enemy) || break }
##    move!(2, 2)
  end

  def turn(:defender, bot, refpid, game) do
    # FIXME will call move, attack
##    return if $game.over?
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(3, enemy) || break }
  end

  def turn(:scout, bot, refpid, game) do
    # FIXME will call move, attack
##    return if $game.over?
##    seek_flag
##
##    @strength = @attack
##    victims = can_attack
##    victims.each {|enemy| try_attack(1, enemy) || break }
##    move!(3, 3)
  end

  def mainloop(bot, refpid, game) do
    # the bot lives its life -- run, attack, whatever
    # see 'turn' in Ruby version
    turn(bot.kind, bot, refpid, game)
    mainloop(bot, refpid, game)
  end

  def awaken(bot, refpid, game) do 
    spawn Bot, :mainloop, [refpid, game]
  end

end
