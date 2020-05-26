defmodule Vincy.Cache do
  def set(service, key, value) do
    Redix.command(:redix, ["SET", "#{service}-#{key}", value])
  end

  def get(service, key) do
    Redix.command(:redix, ["GET", "#{service}-#{key}"])
  end

  def expire(service, key, ttl) when is_integer(ttl) do
    Redix.command(:redix, ["EXPIRE", "#{service}-#{key}", ttl])
  end

  def expire(service, key, ttl) when is_binary(ttl) do
    ttl = String.to_integer(ttl)

    Redix.command(:redix, ["EXPIRE", "#{service}-#{key}", ttl])
  end

  def ttl(service, key) do
    case Redix.command(:redix, ["TTL", "#{service}-#{key}"]) do
      {:ok, ttl} when ttl > 0 -> {:ok, ttl} |> IO.inspect()
      {_, err} -> {:error, err}
    end
  end
end
