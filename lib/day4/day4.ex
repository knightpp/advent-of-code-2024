defmodule Aoc2024.Day4 do
  def part1(input \\ load_input()) do
    input =
      String.splitter(input, "\n", trim: true)
      |> Enum.to_list()

    transposed_input =
      input |> Enum.map(&String.to_charlist/1) |> transpose() |> Enum.map(&to_string/1)

    diagonals_input =
      input
      |> Enum.map(&String.to_charlist/1)
      |> scan_diagonals(byte_size("XMAS"))
      |> Enum.map(&to_string/1)

    diagonals_aux_input =
      input
      |> Enum.map(&String.to_charlist/1)
      |> Enum.map(&Enum.reverse/1)
      |> scan_diagonals(byte_size("XMAS"))
      |> Enum.map(&to_string/1)

    ["XMAS", "SAMX"]
    |> Stream.map(fn term ->
      count_horizontal(input, term) +
        count_horizontal(transposed_input, term) +
        count_horizontal(diagonals_input, term) +
        count_horizontal(diagonals_aux_input, term)
    end)
    |> Enum.sum()
  end

  defp load_input() do
    File.read!("lib/day4/input.txt")
    |> String.trim()
  end

  defp count_horizontal(input, term) do
    Enum.reduce(input, 0, fn el, acc -> acc + string_occurences(el, term) end)
  end

  defp transpose(enum) do
    Enum.zip_with(enum, &Function.identity/1)
  end

  defp scan_diagonals(input, size) do
    input
    |> diagonals()
    |> Enum.filter(fn diag -> Enum.count(diag) >= size end)
  end

  defp diagonals([line | rest] = enum) do
    upper_right_half =
      line
      |> Stream.with_index()
      |> Stream.map(fn {_, index} -> diagonal(enum, index) end)

    lower_left_half = get_lower_left_half(rest)

    Stream.concat(lower_left_half, upper_right_half)
    |> Enum.to_list()
  end

  defp get_lower_left_half([]), do: []

  defp get_lower_left_half(matrix) do
    [diagonal(matrix, 0) | get_lower_left_half(matrix |> Enum.drop(1))]
  end

  defp diagonal([], _), do: []

  defp diagonal([enum | rest], slide) do
    enum
    |> Enum.drop(slide)
    |> Enum.take(1)
    |> Enum.flat_map(fn char ->
      [char | diagonal(rest, slide + 1)]
    end)
  end

  defp string_occurences(string, term) do
    String.split(string, term) |> Enum.drop(1) |> length()
  end
end
