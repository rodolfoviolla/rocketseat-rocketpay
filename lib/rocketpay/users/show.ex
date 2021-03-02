defmodule Rocketpay.User.Show do
  alias Rocketpay.{Repo, User}

  def call(%{"id" => id}) do
    user =
      Repo.get(User, id)
      |> Repo.preload(:account)

    {:ok, user}
  end
end
