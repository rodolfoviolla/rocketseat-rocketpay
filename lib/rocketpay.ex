defmodule Rocketpay do
  alias Rocketpay.User.Create, as: UserCreate
  alias Rocketpay.User.Index, as: UsersIndex
  alias Rocketpay.User.Show, as: UserShow

  alias Rocketpay.Account.{Deposit, Transaction, Withdraw}

  defdelegate create_user(params), to: UserCreate, as: :call
  defdelegate index_users(), to: UsersIndex, as: :call
  defdelegate show_user(params), to: UserShow, as: :call

  defdelegate deposit(params), to: Deposit, as: :call
  defdelegate withdraw(params), to: Withdraw, as: :call
  defdelegate transaction(params), to: Transaction, as: :call
end
