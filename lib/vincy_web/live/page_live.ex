defmodule VincyWeb.PageLive do
  use VincyWeb, :live_view
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    hash = Vincy.Hash.generate("linkr")

    {:ok,
     assign(socket,
       hash: hash,
       valid_hash?: true,
       shortened_link: nil,
       valid_link?: true,
       long_link: "",
       preferred_link: ""
     )}
  end

  @impl true
  def handle_event("save", %{"long_link" => long_link, "custom_path" => custom_path}, socket) do
    preferred_short_link = get_preferred_hash(custom_path, socket)
    Vincy.Cache.set("linkr", preferred_short_link, long_link)
    {:noreply, assign(socket, shortened_link: "vin.cy/#{preferred_short_link}")}
  end

  def handle_event("new_link", _, socket) do
    hash = Vincy.Hash.generate("linkr")

    {:noreply,
     assign(socket,
       hash: hash,
       valid_hash?: true,
       shortened_link: nil,
       valid_link?: true,
       long_link: "",
       preferred_link: ""
     )}
  end

  def handle_event(
        "validate",
        %{"_target" => ["custom_path"], "custom_path" => path},
        socket
      ) do
    case Vincy.Cache.get("linkr", get_preferred_hash(path, socket)) do
      {:ok, nil} ->
        {:noreply, assign(socket, valid_hash?: true, preferred_link: path)}

      _ ->
        {:noreply, assign(socket, valid_hash?: false, preferred_link: path)}
    end
  end

  def handle_event(
        "validate",
        %{"_target" => ["long_link"], "long_link" => long_link},
        socket
      ) do
    case validate_uri(long_link) do
      {:ok, _uri} -> {:noreply, assign(socket, valid_link?: true, long_link: long_link)}
      {:error, _uri} -> {:noreply, assign(socket, valid_link?: false, long_link: long_link)}
    end
  end

  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  defp get_preferred_hash(from_params, socket) do
    if from_params == "" do
      socket.assigns.hash
    else
      from_params
    end
  end

  defp validate_uri(str) do
    uri = URI.parse(str)

    case uri do
      %URI{scheme: nil} -> {:error, uri}
      %URI{host: nil} -> {:error, uri}
      uri -> {:ok, uri}
    end
  end
end
