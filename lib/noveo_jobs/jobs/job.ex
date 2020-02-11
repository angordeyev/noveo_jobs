defmodule Job do
  use Ecto.Schema

  schema "jobs" do
    field :profession_id, :integer
    field :contract_type, :string
    field :name,          :string
    field :location,      Geo.Point
  end

  def changeset(job, params \\ %{}) do
    job
    |> Ecto.Changeset.cast(params, [:profession_id, :contract_type, :name, :location])
  end

end