defmodule Aoc2024.Day3Test do
  use ExUnit.Case, async: true

  describe "part1" do
    test "example" do
      input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
      assert 161 = Aoc2024.Day3.part1(input)
    end
  end

  describe "part2" do
    test "example" do
      input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
      assert 48 = Aoc2024.Day3.part2(input)
    end
  end
end
