defmodule DiceSummon.Invite do
  alias DiceSummon.Cache

  def send_invite(to_user, from_user) do
    case Cache.get("socket:#{to_user}") do
      nil ->
        {:error, "User #{to_user} is not online"}

      pid ->
        send(pid, {:ws_invite, from_user})
        :ok
    end
  end

  @doc """
  Trata resposta de convite com booleano (true = aceito, false = recusado).
  """
  def respond_to_invite(from_user, to_user, true) do
    notify_invite_response(from_user, to_user, "accepted")
  end

  def respond_to_invite(from_user, to_user, false) do
    notify_invite_response(from_user, to_user, "rejected")
  end

  defp notify_invite_response(to_user, from_user, status) do
    case Cache.get("socket:#{to_user}") do
      nil ->
        {:error, "User #{to_user} is not online"}

      pid ->
        send(pid, {:ws_invite_response, from_user, status})
        :ok
    end
  end
end
