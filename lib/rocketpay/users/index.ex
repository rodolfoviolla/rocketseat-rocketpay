defmodule Rocketpay.User.Index do
  alias Rocketpay.{Repo, User}

  def call() do
    users =
      Repo.all(User)
      |> Repo.preload(:account)

    {:ok, users}
  end
end
