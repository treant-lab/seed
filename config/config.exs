import Config

config :bcrypt_elixir, log_rounds: 4

config :joken, default_signer: "secret"

import_config "#{config_env()}.exs"

config :seed, :app_id, "f326f26f-eec8-43aa-b0b4-5b70dbbf73bc"
