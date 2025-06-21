defmodule DiceSummon.AuthenticationHandler do
  alias DiceSummon.UsersRepository
  alias DiceSummon.Cache
  import Bcrypt, only: [verify_pass: 2]

  def authenticate_user(username, password) do
    case UsersRepository.get_user_by_username(username) do
      nil ->
        {:error, "Invalid credentials"}

      user ->
        if verify_pass(password, user.password) do
          Cache.put("socket:#{user.username}", self())
          {:ok, user}
        else
          {:error, "Invalid credentials"}
        end
    end
  end
end
