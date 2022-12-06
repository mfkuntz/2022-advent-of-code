defmodule Advent.DaySix do
  require Logger
  @path "./lib/days/six/input_6.txt"

  # @example [
  #   "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
  #   "bvwbjplbgvbhsrlpgdmjqwftvncz",
  #   "nppdvjthqldpwncqszvftbrmjlhg",
  #   "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
  #   "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
  # ]

  def run() do
    Logger.info("starting day 6")
    lines = Advent.Utils.read_file_lines!(@path)

    # the real puzzle input is 1 line
    Enum.each(lines, &part_1/1)

    Enum.each(lines, &part_2/1)
  end

  defp part_1(lines) do
    index = solver(lines, 4)
    # looking for the LAST char of the unique set not the first
    Logger.debug("part 1: " <> inspect(index + 4))
  end

  defp part_2(lines) do
    index = solver(lines, 14)
    Logger.debug("part 2: " <> inspect(index + 14))
  end

  defp solver(lines, length_of_packet) do
    chars = String.codepoints(lines)
    len = length(chars)

    Range.new(0, len)
    |> Enum.find_index(fn it ->
      items =
        Enum.slice(chars, it, length_of_packet)
        |> Enum.uniq()

      length(items) == length_of_packet
    end)
  end
end
