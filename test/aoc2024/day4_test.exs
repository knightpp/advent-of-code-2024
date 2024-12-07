defmodule Aoc2024.Day4Test do
  use ExUnit.Case, async: true

  describe "part1" do
    test "example" do
      input = """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """

      assert 18 = Aoc2024.Day4.part1(input)
    end
  end
end
