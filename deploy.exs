
defmodule Helper do
  def list_machines do
    {machines_raw, 0} = System.cmd("fly", ["machine", "list", "--json"])
    Jason.decode(machines_raw)
  end
end
[new_image_ref] = System.argv()

{:ok, old_machines} = Helper.list_machines()
IO.puts("old machines")
old_machines
|> Enum.map(& &1["id"])
|> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

System.cmd("fly", ["scale", "count", to_string(Enum.count(old_machines) * 2), "--yes"])

{:ok, new_machines} = Helper.list_machines()
new_machines =
  new_machines
  |> Enum.reject(fn m -> Enum.any?(old_machines, & &1["id"] == m["id"]) end)

for machine <- new_machines do
  System.cmd("fly", ["machine", "update", machine["id"], "--image", new_image_ref, "--yes"])
end

IO.puts("new machines")
new_machines
|> Enum.map(& &1["id"])
|> IO.inspect(label: "#{__MODULE__}:#{__ENV__.line} #{DateTime.utc_now}", limit: :infinity)

for machine <- old_machines do
  IO.puts("shutting down #{machine["id"]} for new requests")
  System.cmd("fly", ["machine", "exec", machine["id"], "/app/bin/graceful_deploy rpc \"AppHealth.down\""])
end
