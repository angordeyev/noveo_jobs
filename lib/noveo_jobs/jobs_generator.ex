defmodule JobsGenerator do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: JobsGenerator)
  end

  @impl true
  def init(_) do
    spawn_link(&generate_jobs/0)
    {:ok, []}
  end

  defp generate_jobs() do
    :timer.sleep(1000);
    IO.puts "ping"

    # add({category, continent})

    generate_jobs()
  end

end