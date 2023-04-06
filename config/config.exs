import Config

config :bcrypt_elixir, log_rounds: 4

config :joken, default_signer: "secret"

import_config "#{config_env()}.exs"

config :seed, :app_id, "8d6023bc-d3ce-11ed-95f0-18c04df1b012"
