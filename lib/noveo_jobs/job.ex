defmodule Job do
  use Ecto.Schema

  schema "jobs" do
    field :continent_id,  :integer
    field :profession_id, :integer
    field :contract_type, :string
    field :name,          :string
    field :location,      Geo.PostGIS.Geometry
  end

  def changeset(job, params \\ %{}) do
    job
    |> Ecto.Changeset.cast(params, [:profession_id, :contract_type, :name, :location])
  end

  def insert(continent_id, profession_id, contact_type, name, location) do
    NoveoJobs.Repo.insert(%Job{name: "hello", location: %Geo.Point{coordinates: {30, -90}}})
  end

end