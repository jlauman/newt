defmodule Newt.WebSocketHandler do
  @behaviour :cowboy_websocket_handler

  require IEx

  def init(_, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  @timeout   20_000 # terminate if no activity for twenty seconds
  @interval  3_000  # send time message every three seconds

  # called on websocket connection init
  def websocket_init(_type, req, _opts) do
    Process.send_after(self, :time_message, @interval)
    state = %{}
    {:ok, req, state, @timeout}
  end

  # handle 'ping' messages from the browser - reply
  def websocket_handle({:text, "ping"}, req, state) do
    {:reply, {:text, "pong"}, req, state}
  end

  # Handle other messages from the browser - don't reply
  def websocket_handle({:text, message}, req, state) do
    %{ "message" => message} = Poison.decode!(message)
    IO.puts("message=#{message}")
    reply = Poison.encode!(%{ ok: String.reverse(message)})
    {:reply, {:text, reply}, req, state}
  end

  def websocket_info(:time_message, req, state) do
    time = Timex.DateTime.now |> Timex.format!("{ISO}")
    reply = Poison.encode!(%{ time: time})
    Process.send_after(self, :time_message, @interval)
    {:reply, {:text, reply}, req, state}
  end

  # Format and forward elixir messages to client
  def websocket_info(message, req, state) do
    {:reply, {:text, message}, req, state}
  end

  # fallback message handler
  def websocket_info(_info, req, state) do
    {:ok, req, state}
  end

  # No matter why we terminate, remove all of this pids subscriptions
  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

end
