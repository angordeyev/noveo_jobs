defmodule NoveoJobs.Repo.Migrations.Jobs do
  use Ecto.Migration

  def change do

    create table(:continents) do
      add :name, :string
    end

    create table(:professions) do
      add :name, :string
      add :category_name, :string
    end

    create table(:jobs) do
      add :continent_id, references(:continents)
      add :profession_id, references(:professions)
      add :contract_type, :string
      add :name,          :string
      add :location,      :geography
    end
    create index(:jobs, [:location]) # for faster search in radius
    create index(:jobs, [:continent_id])
    create index(:jobs, [:profession_id])
  end
end
