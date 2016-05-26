defmodule Newt.Router do
  use Plug.Router

  plug :match
  plug Plug.Static, at: "/lib", from: {:newt, "priv/lib"}
  plug :dispatch

  get "/" do
    send_file(conn, 200, "priv/index.html")
  end

  get "/elm" do
    send_file(conn, 200, "priv/elm/index.html")
  end

  get "/elm/:filename" do
    send_file(conn, 200, "priv/elm/#{filename}")
  end

  get "/react" do
    send_file(conn, 200, "priv/react/index.html")
  end

  get "/react/:filename" do
    send_file(conn, 200, "priv/react/#{filename}")
  end

  get "/vanilla" do
    send_file(conn, 200, "priv/vanilla/index.html")
  end

  get "/vanilla/:filename" do
    send_file(conn, 200, "priv/vanilla/#{filename}")
  end

  get "/hello" do
    send_resp(conn, 200, "world!")
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
