import Config

config :seed, :app_id, "f326f26f-eec8-43aa-b0b4-5b70dbbf73bc"

config :bcrypt_elixir, log_rounds: 4

import_config "#{config_env()}.exs"
