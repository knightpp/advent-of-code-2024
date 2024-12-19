defmodule Aoc2024.Day10Test do
  use ExUnit.Case, async: true

  # @input """
  # 89010123
  # 78121874
  # 87430965
  # 96549874
  # 45678903
  # 32019012
  # 01329801
  # 10456732
  # """
  @input """
  ...0...
  ...1...
  ...2...
  6543456
  7.....7
  8.....8
  9.....9
  """

  describe "part1" do
    test "example" do
      assert 36 = dbg(Aoc2024.Day10.part1(@input))
    end
  end
end
