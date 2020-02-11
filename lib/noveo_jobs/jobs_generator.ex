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
    ProfessionsReport.add({"Tech", "Asia"})
    :timer.tc(fn -> MicroTimer.usleep(50) end)
    generate_jobs()
  end

end