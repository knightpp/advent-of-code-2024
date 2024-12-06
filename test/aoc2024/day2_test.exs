defmodule Aoc2024.Day2Test do
  use ExUnit.Case, async: true
  import Aoc2024.Day2

  describe "part2" do
    test "example1" do
      assert :safe = tolerate_is_safe?([7, 6, 4, 2, 1], 1)
    end

    test "example2" do
      assert :unsafe = tolerate_is_safe?([1, 2, 7, 8, 9], 1)
    end

    test "example3" do
      assert :unsafe = tolerate_is_safe?([9, 7, 6, 2, 1], 1)
    end

    test "example4" do
      assert :safe = tolerate_is_safe?([1, 3, 2, 4, 5], 1)
    end

    test "example5" do
      assert :safe = tolerate_is_safe?([8, 6, 4, 4, 1], 1)
    end

    test "example6" do
      assert :safe = tolerate_is_safe?([1, 3, 6, 7, 9], 1)
    end

    test "custom 1" do
      assert :safe = tolerate_is_safe?([77, 70, 69, 66, 63], 1)
    end
  end
end
