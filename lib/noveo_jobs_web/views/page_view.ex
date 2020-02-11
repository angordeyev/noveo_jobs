defmodule NoveoJobsWeb.PageView do
  use NoveoJobsWeb, :view

  def header do
    ProfessionsReport.get_rendered() |> hd
  end

  def table do
    ProfessionsReport.get_rendered() |> Enum.drop(1)
  end

end
