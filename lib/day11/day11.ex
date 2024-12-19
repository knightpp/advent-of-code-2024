defmodule Aoc2024.Day11 do
  require Integer

  def part1(repeat \\ 25) do
    part1(load_input(), repeat)
  end

  def part1(input, repeat) do
    :ets.new(__MODULE__, [:named_table, :set, :public])

    input =
      input
      |> parse_input()

    1..repeat
    |> Enum.reduce(input, fn _, acc -> next_generation(acc) end)
    |> Enum.count()

    # 1..repeat
    # |> Enum.reduce(Flow.from_enumerable(input), fn _, acc -> next_generation(acc) end)
    # |> Enum.count()
  end

  defp load_input() do
    "17639 47 3858 0 470624 9467423 5 188"
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.splitter(" ", trim: true)
    |> Enum.map(fn x ->
      {num, ""} = Integer.parse(x)
      num
    end)
  end

  defp next_generation(enum) do
    # enum
    # |> Task.async_stream(&memoized_apply_rules/1)
    # |> Stream.flat_map(fn {:ok, result} -> result end)

    # enum
    # |> Flow.from_enumerable()
    # |> Flow.flat_map(&apply_rules/1)
    # enum
    # |> Flow.flat_map(&apply_rules/1)
    # enum
    # |> Flow.map(&apply_rules/1)
    # |> Flow.flat_map(&Function.identity/1)

    enum
    |> Stream.flat_map(&memoized_apply_rules/1)
  end

  defp memoized_apply_rules(x) do
    case :ets.lookup(__MODULE__, x) do
      [{^x, ans}] ->
        ans

      [] ->
        ans = apply_rules(x)
        true = :ets.insert(__MODULE__, {x, ans})
        ans
    end
  end

  defp apply_rules(0), do: [1]

  defp apply_rules(x) do
    digits = Integer.digits(x)
    len = length(digits)

    if Integer.is_even(len) do
      {left, right} = Enum.split(digits, div(len, 2))
      [Integer.undigits(left), Integer.undigits(right)]
    else
      [x * 2024]
    end
  end
end
