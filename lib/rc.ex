defmodule RC do
  # copied from https://rosettacode.org/wiki/Permutations#Elixir
  def permute([]), do: [[]]

  def permute(list) do
    for x <- list, y <- permute(list -- [x]), do: [x | y]
  end

  # TODO: understand this :(
  # copied from https://rosettacode.org/wiki/Permutations_with_repetitions#Elixir
  def perm_rep(list), do: perm_rep(list, length(list))

  def perm_rep([], _), do: [[]]
  def perm_rep(_, 0), do: [[]]

  def perm_rep(list, i) do
    for x <- list, y <- perm_rep(list, i - 1), do: [x | y]
  end
end
