defmodule Paperhub.Projects.Calculations.HashId do
  require Ash.Query
  use Ash.Resource.Calculation

  @impl true
  def calculate(records, _opts, _context) do
    sqids = Sqids.new!(min_length: 21)

    Enum.map(records, fn record ->
      Sqids.encode!(sqids, List.wrap(record.id))
    end)
  end
end
