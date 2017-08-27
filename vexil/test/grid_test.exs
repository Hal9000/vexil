defmodule GridTest do
  use ExUnit.Case

  test "put and get" do
    grid = %{}
    where = {:red, 3, 5}
    val = "foo"
    grid = Grid.put(grid, where, val)
    assert Grid.get(grid, where) == val
  end

  test "show cell" do
    grid = Grid.put(%{}, {:red, 1, 1}, "piece")    
    assert Grid.show_cell(grid, 1, 2) == :ok
  end



end
