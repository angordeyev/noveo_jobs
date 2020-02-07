defmodule NoveoJobsWeb.PageView do
  use NoveoJobsWeb, :view

  def header do
    ProfessionsReport.init_table() |> ProfessionsReport.render() |> hd
  end

  def table do
    ProfessionsReport.init_table() |> ProfessionsReport.render() |> Enum.drop(1)
  end

end
