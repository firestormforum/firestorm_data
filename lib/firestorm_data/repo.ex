defmodule FirestormData.Repo do
  use Ecto.Repo, otp_app: :firestorm_data
  use Scrivener, page_size: 10

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("FIRESTORM_DATABASE_URL"))}
  end
end
