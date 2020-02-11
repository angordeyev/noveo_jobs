# Generates jobs to test the report in real time
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

  # The wait time is 50 microseconds, so about 10000 jobs will be generated per second
  defp generate_jobs() do
    [lat, lon] = GeoServices.random_coordinates()
    continent = GeoServices.get_continent(lat, lon)
    if (continent != "N/A") do
      categories =  {"Tech", "Retail", "Marketing / Comm'", "Créa", "Conseil", "Business", "Admin"}
      last_elem = tuple_size(categories) -1
      category = elem(categories, Enum.random(0..last_elem))
      ProfessionsReport.add({category, continent})
    end
    :timer.tc(fn -> MicroTimer.usleep(50) end) # wait 50 microseconds
    generate_jobs()
  end

end