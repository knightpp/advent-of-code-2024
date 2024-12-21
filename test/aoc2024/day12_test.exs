defmodule Aoc2024.Day12Test do
  use ExUnit.Case, async: true

  @input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  describe "part1" do
    test "example" do
      assert 1930 = Aoc2024.Day12.part1(@input)
    end
  end
end
