defmodule Vincy.Hash do
  @config Hashids.new(salt: "kRHnur", min_len: 3)

  def generate(service) do
    unix_now = Timex.to_unix(Timex.now())

    generated_hash = Hashids.encode(@config, [unix_now])

    case Vincy.Cache.get(service, generated_hash) do
      {:ok, nil} -> generated_hash
      _existing -> generate(service)
    end
  end
end
