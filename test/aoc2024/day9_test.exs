defmodule Aoc2024.Day9Test do
  use ExUnit.Case, async: true

  @input "2333133121414131402"

  describe "part1" do
    test "example" do
      assert 1928 = Aoc2024.Day9.part1(@input)
    end
  end
end
