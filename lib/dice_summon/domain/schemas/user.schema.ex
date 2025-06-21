defmodule DiceSummon.User do
  @enforce_keys [:username, :password_hash]
  defstruct [
    :id,
    :username,
    :password_hash
  ]
end
