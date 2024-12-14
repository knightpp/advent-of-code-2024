defmodule Aoc2024.Day7Test do
  use ExUnit.Case, async: true

  @input """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """

  describe "part1" do
    test "example" do
      assert 3749 = Aoc2024.Day7.part1(@input)
    end
  end

  describe "part2" do
    test "example" do
      assert 11387 = Aoc2024.Day7.part2(@input)
    end
  end
end
