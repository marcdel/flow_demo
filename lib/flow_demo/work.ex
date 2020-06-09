defmodule Work do
  def hard do
    do_work(8..10)
  end

  def medium do
    do_work(1..1)
  end

  def easy do
    do_work(1..1)
  end

  defp do_work(range) do
    {duration, :ok} =
      :timer.tc(fn ->
        range
        |> Enum.random()
        |> :timer.seconds()
        |> Process.sleep()

        :ok
      end)

    duration
  end
end
