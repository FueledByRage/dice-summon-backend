defmodule DiceSummon.Application do
  use Application

  def start(_type, _args) do
    children = [
      DiceSummon.MongoConfig,
      {Cachex, name: :match_cache},
      {
        Plug.Cowboy,
        scheme: :http,
        plug: DiceSummon.Router,
        options: [
          port: 4000,
          dispatch: dispatch_config()
        ]
      }
    ]

    opts = [strategy: :one_for_one, name: DiceSummon.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch_config do
    [
      {:_,
       [
         {"/ws", DiceSummon.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {DiceSummon.Router, []}}
       ]}
    ]
  end
end
