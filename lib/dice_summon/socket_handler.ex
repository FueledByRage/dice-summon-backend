defmodule DiceSummon.SocketHandler do
  @behaviour :cowboy_websocket

  def init(req, _state) do
    query_params = :cowboy_req.parse_qs(req)
    username = List.keyfind(query_params, "username", 0, {"username", nil}) |> elem(1)
    {:cowboy_websocket, req, %{username: username}}
  end

  def websocket_init(state) do
    username = state[:username]

    if username do
      DiceSummon.Cache.put("socket:#{username}", self())
    end

    {:ok, state}
  end

  def websocket_handle({:text, msg}, state) do
    case Jason.decode(msg) do
      {:ok, %{"type" => "invite", "to" => to_user, "from" => from_user}} ->
        case DiceSummon.Invite.send_invite(to_user, from_user) do
          :ok -> {:reply, {:text, "Invite sent to #{to_user}"}, state}
          {:error, reason} -> {:reply, {:text, reason}, state}
        end

      {:ok, %{"type" => "invite_response", "from" => from_user, "response" => decision}} ->
        username = state[:username]

        case DiceSummon.Invite.respond_to_invite(from_user, username, decision) do
          :ok -> {:reply, {:text, "Response sent"}, state}
          {:error, reason} -> {:reply, {:text, reason}, state}
        end

      {:error, _} ->
        {:reply, {:text, "Invalid JSON"}, state}

      _ ->
        {:reply, {:text, "Unknown message type"}, state}
    end
  end

  def websocket_info({:ws_invite_response, responder, status}, state) do
    message = %{
      type: "invite_response",
      from: responder,
      status: status
    }

    {:reply, {:text, Jason.encode!(message)}, state}
  end

  def websocket_info({:ws_invite, from_user}, state) do
    IO.puts("Received invite from #{from_user}")

    message = %{
      type: "invite",
      from: from_user
    }

    {:reply, {:text, Jason.encode!(message)}, state}
  end

  def websocket_info(info, state) do
    IO.inspect(info, label: "websocket_info fallback")
    {:ok, state}
  end

  def terminate(reason, _req, state) do
    IO.inspect({:ws_terminated, reason, state})
    :ok
  end
end
