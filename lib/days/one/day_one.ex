defmodule Advent.DayOne do
  require Logger
  @path "./lib/days/one/input_1.txt"

  def run() do
    Logger.info("starting day 1")
    lines = Advent.Utils.read_file_lines!(@path)
    run_check(lines)
  end

  defp run_check(input) do
    Logger.debug(inspect(input))

    chunks =
      input
      |> Enum.chunk_by(fn it -> it == "" end)
      |> Enum.filter(fn it -> it != [""] end)

    Logger.debug(inspect(chunks))

    totals =
      chunks
      |> Enum.map(fn it ->
        it
        |> Enum.map(fn inner ->
          {r, _} = Integer.parse(inner)
          r
        end)
        |> Enum.sum()
      end)
      |> Enum.sort(:desc)

    Logger.info("max calories for elf 1: " <> inspect(hd(totals)))

    top_3 =
      Enum.to_list(0..2)
      |> Enum.reduce(0, fn it, acc ->
        acc + Enum.at(totals, it)
      end)

    Logger.info("calories of top 3: " <> inspect(top_3))
  end
end
