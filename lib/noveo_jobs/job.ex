defmodule Job do
  use Ecto.Schema

  schema "jobs" do
    field :continent_id,  :integer
    field :profession_id, :integer
    field :contract_type, :string
    field :name,          :string
    field :location,      Geo.PostGIS.Geometry
  end

end