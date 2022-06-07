import Config

config :seed, :app_id, ""

import_config "#{config_env()}.exs"
