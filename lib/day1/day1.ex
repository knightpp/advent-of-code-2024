defmodule Aoc2024.Day1 do
  def part1() do
    {a, b} =
      load_file()
      |> Enum.reduce({Heap.new(), Heap.new()}, &reduce_two_lists/2)

    Stream.zip(a, b)
    |> Stream.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2() do
    {list, map} =
      load_file()
      |> Enum.reduce({[], Map.new()}, fn {a, b}, {acc_a, acc_b} ->
        {[a | acc_a], build_map(b, acc_b)}
      end)

    list
    |> Stream.map(fn x -> x * Map.get(map, x, 0) end)
    |> Enum.sum()
  end

  defp build_map(el, acc), do: Map.get_and_update(acc, el, &upsert_map/1) |> elem(1)
  defp upsert_map(nil), do: {1, 1}
  defp upsert_map(counter), do: {counter, counter + 1}

  defp load_file() do
    File.stream!("lib/day1/input.txt", :line)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [a, b] = String.split(line)
    {a, ""} = Integer.parse(a)
    {b, ""} = Integer.parse(b)
    {a, b}
  end

  defp reduce_two_lists({a, b}, {heap_a, heap_b}) do
    {Heap.push(heap_a, a), Heap.push(heap_b, b)}
  end
end
