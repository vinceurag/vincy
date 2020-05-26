defmodule VincyWeb.LinkrController do
  use VincyWeb, :controller

  def index(conn, %{"hash" => hash}) do
    case Vincy.Cache.get("linkr", hash) do
      {:ok, nil} ->
        redirect(conn, to: "/")

      {:ok, link} ->
        redirect(conn, external: link)

      {:error, _} ->
        redirect(conn, to: "/")
    end
  end
end
