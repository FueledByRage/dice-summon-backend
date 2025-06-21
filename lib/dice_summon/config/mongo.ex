defmodule DiceSummon.MongoConfig do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    # System.get_env("MONGO_URI")
    mongo_uri = "mongodb://localhost:27017/dice_summon"
    Mongo.start_link(url: mongo_uri, name: DiceSummon.Mongo)
  end

  def get_conn do
    GenServer.call(__MODULE__, :get_conn)
  end

  def handle_call(:get_conn, _from, conn) do
    {:reply, conn, conn}
  end
end
