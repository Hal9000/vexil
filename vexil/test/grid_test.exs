defmodule GridTest do
  use ExUnit.Case

  test "put and get" do
    grid = %{}
    where = {:red, 3, 5}
    val = "foo"
    grid = Grid.put(grid, where, val)
    assert Grid.get(grid, where) == val
  end
end
