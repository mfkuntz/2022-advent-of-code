defmodule Mix.Tasks.Advent do
  @shortdoc "Run an advent day"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    case args do
      l when length(l) == 1 -> run_day(hd(l))
      _ -> Mix.shell().info("unknown args")
    end
  end

  defp run_day(day) do
    case day do
      "1" -> Advent.DayOne.run()
      "2" -> Advent.DayTwo.run()
      "3" -> Advent.DayThree.run()
      "4" -> Advent.DayFour.run()
      "5" -> Advent.DayFive.run()
      "6" -> Advent.DaySix.run()
      _ -> Mix.shell().info("unknown or not implemented advent day")
    end
  end
end
