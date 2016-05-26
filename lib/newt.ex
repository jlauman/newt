defmodule Newt do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(ElixirWeb.Worker, [arg1, arg2, arg3]),
      Plug.Adapters.Cowboy.child_spec(:http, Newt.Router, [], dispatch: dispatch, port: 8080)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Newt.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_, [
        {"/favicon.ico", :cowboy_static, {:priv_file, :newt, "favicon.ico"}},
        {"/ws", Newt.WebSocketHandler, []},
        {:_, Plug.Adapters.Cowboy.Handler, {Newt.Router, []}}
      ]}
    ]
  end

end
