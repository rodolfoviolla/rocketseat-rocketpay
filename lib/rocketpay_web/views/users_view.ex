defmodule RocketpayWeb.UsersView do
  use RocketpayWeb, :view

  alias Rocketpay.{Account, User}

  def render("index.json", %{users: users}) do
    render_many(users, __MODULE__, "user.json")
  end

  def render("show.json", %{user: %User{} = user}) do
    render_one(user, __MODULE__, "user.json")
  end

  def render("user.json", %{users: %User{account: %Account{} = account} = user}) do
    %{
      user: %{
        id: user.id,
        name: user.name,
        nickname: user.nickname,
      },
      account: %{
        id: account.id,
        balance: account.balance
      }
    }
  end
end
