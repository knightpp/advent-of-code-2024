defmodule Aoc2024.Day2 do
  def part1() do
    load_file()
    |> Stream.map(&is_safe?/1)
    # this also works
    # |> Stream.map(&tolerate_is_safe?(&1, 0))
    |> Stream.map(&safety_to_integer/1)
    |> Enum.sum()
  end

  def part2() do
    IO.puts("DOES NOT WORK!!!")

    load_file()
    |> Stream.map(&tolerate_is_safe?(&1, 1))
    |> Stream.map(&safety_to_integer/1)
    |> Enum.sum()
  end

  def debug_part2() do
    load_file()
    |> Stream.map(fn line ->
      # part1 = is_safe?(line)
      part2 = tolerate_is_safe?(line, 1)
      # {part1, part2, line}
      {part2, line}
    end)
    # |> Stream.filter(fn {part1, part2, _} -> part1 != part2 end)
    |> Stream.filter(fn {part2, _} -> part2 == :unsafe end)
    |> Enum.to_list()
    |> IO.inspect(charlists: :as_binary, limit: :infinity)

    :ok
  end

  def tolerate_is_safe?(levels, tolerance) do
    IO.inspect(levels, charlists: :as_binary, limit: :infinity)
    less = tolerate_is_safe?(levels, fn a, b -> a < b end, tolerance)

    if less == :safe do
      :safe
    else
      tolerate_is_safe?(levels, fn a, b -> a > b end, tolerance)
    end
  end

  defp compare_levels(a, b, is_steady?) do
    diff = abs(a - b)
    ok = is_steady?.(a, b) and diff >= 1 and diff <= 3
    if ok, do: :safe, else: :unsafe
  end

  defp tolerate_is_safe?(enum, is_steady?, max_tolerance)
       when is_integer(max_tolerance) do
    reducer = fn
      a, {tolerated, nil} ->
        {:cont, {tolerated, a}}

      b, {tolerated, a} ->
        IO.puts("\n>a=#{a} b=#{b}")
        result = compare_levels(a, b, is_steady?)

        if result == :unsafe do
          if tolerated + 1 > max_tolerance do
            {:halt, :unsafe}
          else
            IO.puts(">>acc=#{a}, dropped=#{b}")
            {:cont, {tolerated + 1, a}}
          end
        else
          IO.puts(">>acc=#{b}, chunk=[#{a}, #{b}]")
          {:cont, {tolerated, b}}
        end
    end

    result = Enum.reduce_while(enum, {0, nil}, reducer)
    if result == :unsafe, do: :unsafe, else: :safe
  end

  defp is_safe?([a, b | _] = list) do
    is_steady? =
      if a < b do
        fn a, b -> a < b end
      else
        fn a, b -> a > b end
      end

    is_unsafe =
      Stream.chunk_every(list, 2, 1, :discard)
      |> Stream.map(fn [a, b] ->
        compare_levels(a, b, is_steady?)
      end)
      |> Enum.any?(fn x -> x == :unsafe end)

    if is_unsafe, do: :unsafe, else: :safe
  end

  defp safety_to_integer(:safe), do: 1
  defp safety_to_integer(:unsafe), do: 0

  defp load_file() do
    File.stream!("lib/day2/true.txt", :line)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    list = String.split(line)

    list
    |> Enum.map(fn el ->
      {x, ""} = Integer.parse(el)
      x
    end)
  end
end
