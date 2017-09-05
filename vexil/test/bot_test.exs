defmodule BotTest do
  use ExUnit.Case

  test "where" do
    bob = Bot.scout(:red, 1, 5)
    assert Bot.where(bob) == {1, 5}
  end

  test "enemy? true when two bots different colors" do
    bob = Bot.scout(:red, 1, 5)
    nik = Bot.scout(:blue, 2, 6)
    assert Bot.enemy?(bob, nik)
  end

  test "enemy? false when two bots same color" do
    bob = Bot.scout(:red, 1, 5)
    nik = Bot.scout(:red, 2, 6)
    refute Bot.enemy?(bob, nik)
  end


end
