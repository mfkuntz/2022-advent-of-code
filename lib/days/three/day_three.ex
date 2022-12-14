defmodule Advent.DayThree do
  require Logger
  @path "./lib/days/three/input_3.txt"

  # @example [
  #   "vJrwpWtwJgWrhcsFMMfFFhFp",
  #   "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
  #   "PmmdzqPrVvPwwTWBwg",
  #   "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
  #   "ttgJtRGJQctTZtZT",
  #   "CrZsJsPPZsGzwwsLwLmpwMDw"
  # ]

  @alphabet String.split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", "")

  def run() do
    Logger.info("starting day 3")
    lines = Advent.Utils.read_file_lines!(@path)
    part_1(lines)
    part_2(lines)
  end

  defp part_1(lines) do
    total =
      lines
      |> Enum.map(fn it ->
        len = String.length(it)
        middle = trunc(len / 2)

        [a, b] =
          String.codepoints(it)
          |> Enum.chunk_every(middle)

        v = MapSet.intersection(new_map(a), new_map(b)) |> MapSet.to_list()

        Enum.find_index(@alphabet, fn a -> a == hd(v) end)
      end)
      |> Enum.sum()

    Logger.debug("part 1: " <> inspect(total))
  end

  defp part_2(lines) do
    total =
      lines
      |> Enum.chunk_every(3)
      |> Enum.map(fn it ->
        [a, b, c] = it

        v =
          MapSet.intersection(new_map(a), new_map(b))
          |> MapSet.intersection(new_map(c))
          |> MapSet.to_list()

        Enum.find_index(@alphabet, fn a -> a == hd(v) end)
      end)
      |> Enum.sum()

    Logger.debug("part 2: " <> inspect(total))
  end

  defp new_map(lines) when is_binary(lines), do: new_map(String.codepoints(lines))
  defp new_map(lines), do: MapSet.new(lines)
end
