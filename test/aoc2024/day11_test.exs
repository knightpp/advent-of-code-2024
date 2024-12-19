defmodule Aoc2024.Day11Test do
  use ExUnit.Case, async: true

  @input "125 17"

  describe "part1" do
    test "example" do
      assert 55312 = Aoc2024.Day11.part1(@input, 25)
    end
  end
end
