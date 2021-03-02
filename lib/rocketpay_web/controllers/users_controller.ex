defmodule RocketpayWeb.UsersController do
  use RocketpayWeb, :controller

  alias Rocketpay.User

  action_fallback RocketpayWeb.FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Rocketpay.create_user(params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, params) do
    with {:ok, %User{} = user} <- Rocketpay.show_user(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  def index(conn, _params) do
    with {:ok, users} <- Rocketpay.index_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end
end
