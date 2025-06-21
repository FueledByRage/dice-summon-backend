defmodule DiceSummon.Router do
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  plug(:dispatch)

  post "/login" do
    case conn.body_params do
      %{"username" => username, "password" => password} ->
        case DiceSummon.AuthenticationHandler.authenticate_user(username, password) do
          {:ok, user} ->
            send_resp(
              conn,
              200,
              Jason.encode!(%{message: "Logged in", user: %{username: user.username}})
            )

          {:error, reason} ->
            send_resp(conn, 401, Jason.encode!(%{error: reason}))
        end

      _ ->
        send_resp(conn, 400, Jason.encode!(%{error: "Invalid body"}))
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
