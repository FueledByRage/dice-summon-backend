defmodule DiceSummon.User do
  @enforce_keys [:username, :password]
  defstruct [
    :id,
    :username,
    :password
  ]
end
