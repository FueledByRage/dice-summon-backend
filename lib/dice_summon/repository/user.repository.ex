defmodule DiceSummon.UsersRepository do
  alias DiceSummon.{MongoConfig, User}

  def create_user(%User{} = user) do
    conn = MongoConfig.get_conn()
    doc = Map.from_struct(user) |> Map.delete(:id)

    case Mongo.insert_one(conn, "users", doc) do
      {:ok, %{inserted_id: id}} ->
        {:ok, %User{user | id: id}}

      error ->
        error
    end
  end

  def get_user_by_username(username) do
    conn = MongoConfig.get_conn()

    case Mongo.find_one(conn, "users", %{username: username}) do
      nil -> nil
      doc -> to_user(doc)
    end
  end

  defp to_user(%{"_id" => id} = doc) do
    %User{
      id: id,
      username: doc["username"],
      password: doc["password"]
    }
  end
end
