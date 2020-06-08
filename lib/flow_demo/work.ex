defmodule Work do
  def hard do
    #    do_work(3..3)
    do_work(9..10)
  end

  def medium do
    #    do_work(2..2)
#    do_work(3..4)
  end

  def easy do
    #    do_work(1..1)
#    do_work(1..2)
  end

  defp do_work(range) do
#    range
#    |> Enum.random()
#    |> :timer.seconds()
#    |> Process.sleep()
  end
end
