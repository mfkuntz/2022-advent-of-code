defmodule Advent.DayOne do

  require Logger

  def run() do
    Logger.info("starting day 1")
    path = Path.relative_to_cwd("./lib/days/one/input_1.txt")
    Logger.debug("reading file input: " <> inspect(path))
    case File.read(path) do
      {:ok, d} -> run_check(d)
      {:error, reason} -> Logger.error("error reading input file: " <> to_string(:file.format_error(reason)))
    end
  end

  defp run_check(input) do
    input = input |> String.split("\n")
    Logger.debug(inspect(input))

    chunks = input
    |> Enum.chunk_by(fn it -> it == "" end)
    |> Enum.filter(fn it -> it != [""] end)
    Logger.debug(inspect(chunks))


    totals = chunks
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

    top_3 = Enum.to_list(0..2)
    |> Enum.reduce(0, fn it, acc ->
      acc + Enum.at(totals, it)
    end)
    Logger.info("calories of top 3: " <> inspect(top_3))

  end

end
