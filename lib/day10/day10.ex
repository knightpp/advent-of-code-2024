defmodule Aoc2024.Day10 do
  def part1(input) do
    IO.puts("does not work")

    input
    |> parse_input()
    |> tap(&dbg/1)
    |> find_trails()
  end

  defp parse_input(input) when is_binary(input) do
    input
    |> String.splitter("\n", trim: true)
    |> parse_input()
  end

  defp parse_input(input) do
    input
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn {line, y}, acc ->
      line
      |> String.to_charlist()
      |> Stream.map(&(&1 - ?0))
      |> Stream.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end

  defp find_trails(map) do
    map
    |> Stream.filter(&(elem(&1, 1) == 0))
    |> Stream.map(fn {pos, _height} ->
      find_trails(pos, map) |> Enum.filter(fn x -> x == [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] end)
    end)
    |> Enum.to_list()

    # |> Enum.sum()
  end

  defp find_trails({x, y} = current, map, acc \\ []) do
    height = get_in(map[current])

    case height do
      nil ->
        []

      9 ->
        [[current | acc]]

      _ ->
        left = {x - 1, y}
        right = {x + 1, y}
        up = {x, y - 1}
        down = {x, y + 1}

        [left, right, up, down]
        |> Enum.flat_map(fn neighbor ->
          if height + 1 == get_in(map[neighbor]) do
            # this generates incorrect order
            find_trails(neighbor, map, [current | acc])
          else
            []
          end
        end)
    end
  end
end
