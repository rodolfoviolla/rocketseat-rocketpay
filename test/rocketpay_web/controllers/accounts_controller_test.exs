defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Rodolfo",
        password: "123456",
        nickname: "rodolfo",
        email: "rodolfo@email.com",
        age: 31
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

      username = System.get_env("APP_USERNAME")
      password = System.get_env("APP_PASSWORD")
      authorization_key = Base.encode64("#{username}:#{password}")

      conn = put_req_header(conn, "authorization", "Basic #{authorization_key}")

      {:ok, conn: conn, account_id: account_id}
    end

    test "When all params are valid, make the deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => 50}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      expected_response = %{
        "account" => %{"balance" => "50.00", "id" => account_id},
        "message" => "Balance updated successfully"
      }

      assert response == expected_response
    end

    test "When there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid deposit value."}

      assert response == expected_response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      user_params = %{
        name: "Rodolfo",
        password: "123456",
        nickname: "rodolfo",
        email: "rodolfo@email.com",
        age: 31
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(user_params)

      username = System.get_env("APP_USERNAME")
      password = System.get_env("APP_PASSWORD")
      authorization_key = Base.encode64("#{username}:#{password}")

      conn = put_req_header(conn, "authorization", "Basic #{authorization_key}")

      {:ok, conn: conn, account_id: account_id}
    end

    test "When all params are valid and account has enough balance, make the withdraw", %{conn: conn, account_id: account_id} do
      deposit_params = %{"value" => 50}

      conn
      |> post(Routes.accounts_path(conn, :deposit, account_id, deposit_params))
      |> json_response(:ok)

      params = %{"value" => 50}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      expected_response = %{
        "account" => %{"balance" => "0.00", "id" => account_id},
        "message" => "Balance updated successfully"
      }

      assert response == expected_response
    end

    test "When all params are valid but account has not enough balance, return an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => 50}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => %{"balance" => ["is invalid"]}}

      assert response == expected_response
    end

    test "When there are invalid params, return an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      expected_response = %{"message" => "Invalid withdraw value."}

      assert response == expected_response
    end
  end
end
